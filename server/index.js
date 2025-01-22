import express from "express";
import mongoose from "mongoose";
import dotenv from "dotenv";
import authRouter from "./routes/auth.js";
dotenv.config();
import cors from "cors";
import documentRouter from "./routes/document.js";
import http from "http";
import socketIo from "socket.io"; // Import the default CommonJS export


// Configure CORS
const corsOptions = {
  origin: '*', // Allow all origins (use specific origin for better security)
  methods: 'GET,HEAD,PUT,PATCH,POST,DELETE', // Allow specific HTTP methods
  allowedHeaders: ['Content-Type', 'Authorization', 'x-auth-token'], // Allow specific headers
};

const PORT = process.env.PORT || 3001;
const app = express();
const server = http.createServer(app); // Create HTTP server instance
const io = socketIo(server, { // Instantiate Socket.IO server
    cors: {
      origin: '*', // Allow all origins (adjust as needed)
      methods: ['GET', 'POST'], // Allowed methods
    },
  });
  

// MongoDB Connection String
const DB = `mongodb+srv://viditmsit:${process.env.DB_Password}@cluster0.kjblz.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0`;

// Middleware
app.use(cors(corsOptions));
app.use(express.json());
app.use(authRouter);
app.use(documentRouter);

// MongoDB Connection
mongoose
  .connect(DB)
  .then(() => {
    console.log('DB connection successful ✌️');
  })
  .catch((error) => {
    console.log(error);
  });

// Socket.IO Event Handling
io.on("connection", (socket) => {
  console.log("A user connected:", socket.id);

  // Example event listener
  socket.on("message", (data) => {
    console.log("Received message:", data);
    socket.emit("reply", { message: "Message received!" }); // Reply to client
  });
  socket.on("join",(documentId)=>{
    socket.join(documentId);
    console.log('joined',documentId);

  });
  socket.on('typing',(data)=>{
    socket.broadcast.to(data.room).emit("changes",data);

  });
  socket.on("save",(data)=>{
    saveData(data);
  })

  socket.on("disconnect", () => {
    console.log("A user disconnected:", socket.id);
  });
});
const saveData = async (data) =>{
    let document = await Document.findById(data.documentId);
    document.content = data.delta;
    document = await document.save();
}

// Start the Server
server.listen(PORT, "0.0.0.0", () => {
  console.log(`Connected at port ${PORT}`);
});
