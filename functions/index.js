const functions = require("firebase-functions");
const fetch = require("node-fetch");
const fs = require("fs");      // 👈 BẮT BUỘC
const os = require("os");      // 👈 BẮT BUỘC (LỖI CỦA M)
const path = require("path");  // 👈 BẮT BUỘC
const axios = require("axios");   
const FormData = require("form-data");
const OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY;
const MODEL = "xiaomi/mimo-v2-flash:free";

const SYSTEM_PROMPT = `
Bạn là BearGo AI.

Danh tính:
- Tên của bạn là BearGo AI.
- Bạn là trợ lý học tiếng Anh trong ứng dụng BearGo.
- Bạn nói chuyện như một người thật, thân thiện và dễ hiểu.

NGÔN NGỮ:
- LUÔN LUÔN trả lời bằng TIẾNG VIỆT.
- Chỉ dùng tiếng Anh khi:
  + đang dịch
  + đưa ví dụ tiếng Anh
  + sửa câu tiếng Anh cho người học

NHIỆM VỤ CHÍNH:
- Giải thích từ vựng tiếng Anh.
- Giải thích ngữ pháp tiếng Anh đơn giản.
- Dịch Anh ↔ Việt.
- Sửa câu tiếng Anh.

GIỚI HẠN:
- Chỉ hỗ trợ học tiếng Anh.
`;
const SPEAKING_SYSTEM_PROMPT = `
Bạn là AI CHẤM KỸ NĂNG NÓI TIẾNG ANH cho ứng dụng BearGo.

NHIỆM VỤ DUY NHẤT:
- So sánh câu USER nói với câu TARGET.

QUY TẮC:
- Nếu nội dung trùng hoặc gần đúng → correct / partial
- Nếu nói khác nội dung hoặc ngoài lề → incorrect
- KHÔNG chat
- KHÔNG khen nếu sai
- KHÔNG sửa câu

CHỈ trả về JSON:
{
  "result": "correct | partial | incorrect",
  "message": "Nhận xét ngắn bằng tiếng Việt"
}
`;

exports.chatBeargoAI = functions.https.onRequest(async (req, res) => {
  res.set("Access-Control-Allow-Origin", "*");
  res.set("Access-Control-Allow-Headers", "Content-Type");

  if (req.method === "OPTIONS") {
    return res.status(204).send("");
  }

  try {
    const userMessage = req.body.message;
const isSpeakingMode = userMessage.startsWith("[SPEAKING]");


    if (!userMessage || userMessage.trim() === "") {
      return res.status(400).json({ error: "Tin nhắn rỗng" });
    }

    const response = await fetch(
      "https://openrouter.ai/api/v1/chat/completions",
      {
        method: "POST",
        headers: {
          "Authorization": `Bearer ${OPENROUTER_API_KEY}`,
          "Content-Type": "application/json",
          "HTTP-Referer": "https://beargo.app",
          "X-Title": "BearGo AI",
        },
        body: JSON.stringify({
          model: MODEL,
          messages: [
  {
    role: "system",
    content: isSpeakingMode ? SPEAKING_SYSTEM_PROMPT : SYSTEM_PROMPT,
  },
  { role: "user", content: userMessage },
],

          temperature: 0.6,
          max_tokens: 300,
        }),
      }
    );

    const data = await response.json();

    const answer = data?.choices?.[0]?.message?.content;

    if (!answer) {
      return res.status(500).json({ error: "AI không trả lời" });
    }

    return res.json({ answer });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: "Lỗi BearGo AI" });
  }
});
const Busboy = require("busboy");
//
exports.transcribeAudio = functions.https.onRequest(async (req, res) => {
  res.set("Access-Control-Allow-Origin", "*");
  res.set("Access-Control-Allow-Headers", "Content-Type");

  if (req.method === "OPTIONS") {
    return res.status(204).send("");
  }

  if (req.method !== "POST") {
    return res.status(405).send("Method Not Allowed");
  }

  try {
    const busboy = Busboy({ headers: req.headers });
    const tmpdir = os.tmpdir();
    let audioFilePath = null;

    busboy.on("file", (fieldname, file, filename) => {
      console.log("🎧 RECEIVED FILE:", filename);

      audioFilePath = path.join(tmpdir, "speech.m4a");
      const writeStream = fs.createWriteStream(audioFilePath);
      file.pipe(writeStream);
    });

    busboy.on("finish", async () => {
      if (!audioFilePath) {
        return res.status(400).json({ error: "Không có file audio" });
      }

      const form = new FormData(); // 👈 npm form-data
      form.append("file", fs.createReadStream(audioFilePath));
      form.append("model", "openai/whisper-1");

      const response = await axios.post(
        "https://openrouter.ai/api/v1/audio/transcriptions",
        form,
        {
          headers: {
            ...form.getHeaders(), // 👈 GIỜ SẼ CÓ
            Authorization: `Bearer ${process.env.OPENROUTER_API_KEY}`,
          },
        }
      );

      return res.json({
        text: response.data.text || "",
      });
    });

    busboy.end(req.rawBody);
  } catch (err) {
    console.error("❌ TRANSCRIBE ERROR:", err);
    return res.status(500).json({ error: "Transcribe failed" });
  }
});

exports.generateMcqQuiz = functions.https.onRequest(async (req, res) => {
  res.set("Access-Control-Allow-Origin", "*");
  res.set("Access-Control-Allow-Headers", "Content-Type");

  if (req.method === "OPTIONS") {
    return res.status(204).send("");
  }

  if (req.method !== "POST") {
    return res.status(405).json({ error: "METHOD_NOT_ALLOWED" });
  }

  try {
    const { topic, count } = req.body;

    if (!topic || !count || count < 1 || count > 20) {
      return res.status(400).json({ error: "INVALID_INPUT" });
    }

    // =========================
    // 🔒 RÀNG BUỘC CHỦ ĐỀ (CHẶN BẬY / SLANG / BẠO LỰC)
    // =========================
    const lowerTopic = topic.toLowerCase();

    const bannedKeywords = [
      // tiếng Việt
      "chém",
      "chém lộn",
      "đâm",
      "đánh nhau",
      "bạo lực",
      "tục",
      "sex",
      "ma túy",
      // tiếng Anh
      "slang",
      "violence",
      "fight",
      "knife",
      "weapon",
      "drug",
      "sexual",
    ];

    for (const word of bannedKeywords) {
      if (lowerTopic.includes(word)) {
        return res.status(400).json({
          error: "INVALID_TOPIC",
          message:
            "Chủ đề này không phù hợp cho bài học tiếng Anh. Vui lòng chọn chủ đề mang tính giáo dục, lành mạnh.",
        });
      }
    }

    // =========================
    // 🧠 PROMPT AI
    // =========================
    const SYSTEM_PROMPT = `
Bạn là AI tạo bài trắc nghiệm tiếng Anh cho ứng dụng BearGo.

YÊU CẦU:
- Chỉ tạo nội dung phục vụ học tiếng Anh (từ vựng, ngữ pháp, đọc hiểu)
- Chủ đề mang tính giáo dục, trung tính (con vật, gia đình, du lịch, đời sống...)
- TUYỆT ĐỐI KHÔNG tạo nội dung:
  + bạo lực
  + slang nhạy cảm
  + chửi thề
  + tình dục
  + ma túy
PHONG CÁCH INTRO:
- Viết intro như một người đồng hành học tập, nói chuyện tự nhiên.
- Xưng "mình – bạn".
- LUÔN LUÔN viết bằng TIẾNG VIỆT.
- Dài 2–4 câu, sinh động, thân thiện.
- Có thể dùng TỐI ĐA 3 emoji (🤖 🐾 📘).
- Tránh văn phong thông báo, tránh khô khan.

BẮT BUỘC:
- Trả về DUY NHẤT JSON
- KHÔNG markdown
- KHÔNG giải thích
- KHÔNG thêm chữ ngoài JSON

FORMAT:
{
  "title": "string",
  "intro": "string",
  "questions": [
    {
      "question": "string",
      "options": [
        { "key": "A", "text": "string" },
        { "key": "B", "text": "string" },
        { "key": "C", "text": "string" },
        { "key": "D", "text": "string" }
      ],
      "correctAnswer": "A"
    }
  ]
}
  
`;

    const USER_PROMPT = `
Tạo CHÍNH XÁC ${count} câu hỏi trắc nghiệm tiếng Anh.
Chủ đề: "${topic}"
`;

    const response = await fetch(
      "https://openrouter.ai/api/v1/chat/completions",
      {
        method: "POST",
        headers: {
          "Authorization": `Bearer ${OPENROUTER_API_KEY}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          model: MODEL,
          messages: [
            { role: "system", content: SYSTEM_PROMPT },
            { role: "user", content: USER_PROMPT },
          ],
          temperature: 0.7,
          max_tokens: 1800,
        }),
      }
    );

    const data = await response.json();
    const content = data?.choices?.[0]?.message?.content;

    if (!content) {
      return res.status(500).json({ error: "AI_NO_RESPONSE" });
    }

    // =========================
    // 🧹 PARSE JSON AN TOÀN
    // =========================
    const start = content.indexOf("{");
    const end = content.lastIndexOf("}");
    if (start === -1 || end === -1) {
      return res.status(500).json({ error: "INVALID_AI_FORMAT" });
    }

    const cleanJson = content.substring(start, end + 1);
    const quiz = JSON.parse(cleanJson);

    return res.json(quiz);
  } catch (err) {
    console.error("❌ generateMcqQuiz ERROR:", err);
    return res.status(500).json({ error: "MCQ_GENERATE_FAILED" });
  }
  
});
// AI ĐÁNH GIÁ NĂNG LỰC THEO KỸ NĂNG
exports.evaluateSkillWithAI = functions.https.onRequest(async (req, res) => {
  res.set("Access-Control-Allow-Origin", "*");
  res.set("Access-Control-Allow-Headers", "Content-Type");

  if (req.method === "OPTIONS") {
    return res.status(204).send("");
  }

  if (req.method !== "POST") {
    return res.status(405).json({ error: "METHOD_NOT_ALLOWED" });
  }

  try {
    const {
      totalQuestions,
      correctAnswers,
      timeSpentSeconds,
      skills,              // breakdown theo kỹ năng
      wrongQuestionTypes,  // danh sách dạng câu sai
    } = req.body;

    if (
      !totalQuestions ||
      correctAnswers === undefined ||
      !skills ||
      typeof skills !== "object"
    ) {
      return res.status(400).json({ error: "INVALID_INPUT" });
    }

    // =========================
    // 🧠 SYSTEM PROMPT – ĐÁNH GIÁ NĂNG LỰC
    // =========================
    const SYSTEM_PROMPT = `
Bạn là BearGo AI – chuyên gia đánh giá năng lực tiếng Anh.

NHIỆM VỤ:
- Đánh giá TRÌNH ĐỘ tiếng Anh của người học dựa trên KẾT QUẢ BÀI TEST.
- KHÔNG tạo câu hỏi.
- KHÔNG dạy lan man.
- KHÔNG chấm từng câu.

PHẠM VI ĐÁNH GIÁ:
- Grammar
- Vocabulary
- Reading
- Listening
(KHÔNG có Speaking)

YÊU CẦU BẮT BUỘC:
- LUÔN trả lời bằng TIẾNG VIỆT.
- Văn phong rõ ràng, mang tính học thuật vừa phải (để giảng viên xem).
- Nhận xét cụ thể, không chung chung.

PHẢI TRẢ VỀ DUY NHẤT JSON (KHÔNG markdown, KHÔNG giải thích ngoài JSON).

FORMAT:
{
  "overallLevel": "A1 | A2 | B1 | B2 | C1",
  "summary": "Nhận xét tổng quát 2–3 câu",
  "skillAnalysis": {
    "grammar": {
      "level": "Yếu | Trung bình | Khá | Tốt",
      "comment": "string"
    },
    "vocabulary": {
      "level": "Yếu | Trung bình | Khá | Tốt",
      "comment": "string"
    },
    "reading": {
      "level": "Yếu | Trung bình | Khá | Tốt",
      "comment": "string"
    },
    "listening": {
      "level": "Yếu | Trung bình | Khá | Tốt",
      "comment": "string"
    }
  },
  "weaknesses": [
    "string"
  ],
  "learningRoadmap": [
    "Bước 1: ...",
    "Bước 2: ...",
    "Bước 3: ..."
  ]
}
`;

    // =========================
    // 👤 USER PROMPT – DỮ LIỆU THẬT
    // =========================
    const USER_PROMPT = `
KẾT QUẢ BÀI TEST:

- Tổng số câu: ${totalQuestions}
- Số câu đúng: ${correctAnswers}
- Thời gian làm bài (giây): ${timeSpentSeconds}

KẾT QUẢ THEO KỸ NĂNG:
${JSON.stringify(skills, null, 2)}

CÁC DẠNG CÂU SAI:
${JSON.stringify(wrongQuestionTypes || [], null, 2)}

Hãy đánh giá năng lực người học và đề xuất lộ trình học phù hợp.
`;

    const response = await fetch(
      "https://openrouter.ai/api/v1/chat/completions",
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${OPENROUTER_API_KEY}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          model: MODEL,
          messages: [
            { role: "system", content: SYSTEM_PROMPT },
            { role: "user", content: USER_PROMPT },
          ],
          temperature: 0.4,
          max_tokens: 900,
        }),
      }
    );

    const data = await response.json();
    const content = data?.choices?.[0]?.message?.content;

    if (!content) {
      return res.status(500).json({ error: "AI_NO_RESPONSE" });
    }

    // =========================
    // 🧹 PARSE JSON AN TOÀN
    // =========================
    const start = content.indexOf("{");
    const end = content.lastIndexOf("}");

    if (start === -1 || end === -1) {
      return res.status(500).json({ error: "INVALID_AI_FORMAT" });
    }

    const cleanJson = content.substring(start, end + 1);
    const result = JSON.parse(cleanJson);

    return res.json(result);
  } catch (err) {
    console.error("❌ evaluateSkillWithAI ERROR:", err);
    return res.status(500).json({ error: "AI_EVALUATION_FAILED" });
  }
});
// ky nangâng aádasd
exports.generateAssessmentTest = functions.https.onRequest(async (req, res) => {
  res.set("Access-Control-Allow-Origin", "*");
  res.set("Access-Control-Allow-Headers", "Content-Type");

  if (req.method === "OPTIONS") return res.status(204).send("");
  if (req.method !== "POST")
    return res.status(405).json({ error: "METHOD_NOT_ALLOWED" });

  try {
    const SYSTEM_PROMPT = `
Bạn là AI tạo BÀI ĐÁNH GIÁ NĂNG LỰC TIẾNG ANH.
YÊU CẦU NGÔN NGỮ (RẤT QUAN TRỌNG):
- TOÀN BỘ câu hỏi và đáp án PHẢI BẰNG TIẾNG ANH.
- TUYỆT ĐỐI KHÔNG dùng tiếng Việt trong câu hỏi hoặc đáp án.
- Chỉ dùng tiếng Việt cho MÔ TẢ HỆ THỐNG (không xuất ra).
MỤC TIÊU:
- Đánh giá trình độ tổng quát người học (Grammar, Vocabulary, Reading)
- KHÔNG dùng để luyện tập
- Độ khó tăng dần

YÊU CẦU:
- Tổng 15 câu
  + 5 Vocabulary
  + 5 Grammar
  + 5 Reading (ngắn)
- Mỗi câu có trường "skill"
- LUÔN viết bằng TIẾNG VIỆT
- CHỈ trả về JSON
- KHÔNG markdown
- KHÔNG giải thích

FORMAT:
{
  "questions": [
    {
      "skill": "grammar | vocabulary | reading",
      "question": "string",
      "options": [
        { "key": "A", "text": "string" },
        { "key": "B", "text": "string" },
        { "key": "C", "text": "string" },
        { "key": "D", "text": "string" }
      ],
      "correctAnswer": "A"
    }
  ]
}
`;

    const response = await fetch(
      "https://openrouter.ai/api/v1/chat/completions",
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${process.env.OPENROUTER_API_KEY}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          model: MODEL,
          messages: [{ role: "system", content: SYSTEM_PROMPT }],
          temperature: 0.6,
          max_tokens: 2500,
        }),
      }
    );

    const data = await response.json();
    const content = data?.choices?.[0]?.message?.content;

    const start = content.indexOf("{");
    const end = content.lastIndexOf("}");
    const json = JSON.parse(content.substring(start, end + 1));

    return res.json(json);
  } catch (e) {
    console.error(e);
    return res.status(500).json({ error: "ASSESSMENT_GENERATE_FAILED" });
  }
});
