What is VideoSR?
==================

Video SR (VSR) is the extension and development of SISR. Compared to single image input, the adjacent frames of videos usually have a certain image time correlation. This time correlation can be used as a priori information to constrain the SR problems, and improve the reconstruction quality of HR videos.

There have been many researches focused on video super resolution, you may need a basic concept of this technique. In this code, we use tensorflow to implement deep model. Note that, the code architecture is from **VideoSuperResolution**, the **origin project** can be seen on `LoSealL/VideoSuperResolution <https://github.com/LoSealL/VideoSuperResolution>`_.

For more documentation, please see the html made by sphinx.

.. note::
    After you clone the code, the first thing is install the package use 

    ``pip install -e .``    

    Evaluate:     

    ``python run.py --model vespcn --test vid4``      

    Train:     

    ``CUDA_VISIBLE_DEVICES=0 python run.py --model vespcn --dataset mcl-v --memory_limit 1GB --epochs 100``     

This code is only used for learning, if you need more details, please **star or fork the origin project as mentioned before**
