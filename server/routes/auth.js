import express from 'express';
import User from '../models/user.js'; // Correct the path if needed

const authRouter = express.Router();

authRouter.post('/api/signup', async (req, res) => {
    try {
        const { name, email, profilePic } = req.body;

        // console.log("Request Body:", req.body); // Log the incoming request body

        // Ensure that email is present
        if (!email) {
            return res.status(400).json({ message: "Email is required" });
        }

        let user = await User.findOne({ email: email });

        if (!user) {
            user = new User({
                email: email, // Ensure this is the correct key
                name: name,
                profilePic: profilePic,
            });

            user = await user.save();
            console.log('User Registered Successfully');
        }

        res.json({ user: user });
    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({ message: "Internal server error" });
    }
});
authRouter.get('/api/v1',(req,res)=>{
    res.send('hello');
})

export default authRouter;
