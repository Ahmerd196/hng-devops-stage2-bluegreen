import express from "express";
const app = express();

app.get("/version", (req, res) => {
  res.json({ version: "1.0.0", status: "ok" });
});

const PORT = process.env.PORT || 3000;
const HOST = "0.0.0.0"; // ✅ Important for Railway
app.listen(PORT, HOST, () => console.log(`Running on http://${HOST}:${PORT}`));
