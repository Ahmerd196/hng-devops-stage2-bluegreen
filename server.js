import express from "express";
const app = express();

app.get("/version", (req, res) => {
  res.json({ version: "1.0.0", status: "ok" });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Running on port ${PORT}`));
