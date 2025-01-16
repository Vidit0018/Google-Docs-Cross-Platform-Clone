import express from "express";
import mongoose, { mongo } from "mongoose";
import dotenv from "dotenv";
import authRouter from "./routes/auth.js";
dotenv.config();
import cors from 'cors';


// Configure CORS
const corsOptions = {
  origin: '*', // Allow all origins (use specific origin for better security)
  methods: 'GET,HEAD,PUT,PATCH,POST,DELETE', // Allow specific HTTP methods
  allowedHeaders: ['Content-Type', 'Authorization','x-auth-token'], // Allow specific headers
};


const app = express();
const PORT  = process.env.PORT || 3001;

const DB = `mongodb+srv://viditmsit:${process.env.DB_Password}@cluster0.kjblz.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0`;
app.use(cors(corsOptions));
app.use(express.json());
app.use(authRouter);

mongoose.connect(DB).then(
    ()=>{console.log('DB connection successful ✌️')}
).catch((error)=>{
    console.log(error);
});

app.listen(PORT , "0.0.0.0" ,()=> {
    console.log(`conneted at port ${PORT}`);
})