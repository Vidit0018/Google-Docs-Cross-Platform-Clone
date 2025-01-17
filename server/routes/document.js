import express from 'express';
import Document  from '../models/document.js';
import auth from '../middlewares/auth.js';

const documentRouter = express.Router();

documentRouter.post('/doc/create',auth ,async(req,res)=>{

    try {
        const {createdAt} = req.body;
        let document = new Document({
            uid: req.user ,
            title: 'Untitled Document',
            createdAt,
        })

        document = await document.save();
        res.json(document);
    } catch (error) {
        res.status(500).json({error: e.message});
    }

});

documentRouter.get('/docs/me',auth,async(req,res)=>{
    try{
        let documents = await Document.find({uid:req.user});
        res.json(documents);
    }catch(e){
        res.status(500).json({error : e.message});
    }
    
})

export default documentRouter;