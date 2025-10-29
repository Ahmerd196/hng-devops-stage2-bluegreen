import express from "express";

const app = express();

app.get("/", (req, res) => {
  res.send("✅ App is live and responding!");
});

app.get("/version", (req, res) => {
  res.json({ version: "1.0.0", status: "ok" });
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Running on http://0.0.0.0:${PORT}`);
});
