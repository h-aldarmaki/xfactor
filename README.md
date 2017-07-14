# About
This is an implementation of cross-lingual matrix factorization using ALS as described in [Learning Cross-lingual Representations with Matrix Factorization] (https://aclweb.org/anthology/W/W16/W16-1201.pdf). This project is based on the orthogonal matrix factorization (OrMF) scripts available [here](http://www.cs.columbia.edu/~weiwei/code.html).

If you use this code, please cite the following papers:

````
@article{aldarmakilearning,
  title={Learning Cross-lingual Representations with Matrix Factorization},
  author={Aldarmaki, Hanan and Diab, Mona},
  booktitle={Proceedings of the Workshop on Multilingual and Cross-lingual Methods in NLP},
  year={2016}
}
```

````
@inproceedings{guo2012modeling,
  title={Modeling sentences in the latent space},
  author={Guo, Weiwei and Diab, Mona},
  booktitle={Proceedings of the 50th Annual Meeting of the Association for Computational Linguistics},
  year={2012}
}

```
# How To

## Preprocessing

Before using this code, it is recommended to tokenize and stem the data. Make sure test sentences are processed the same way as training sentences.

The input files must contain one sentence per line. Digits will be normalized and all characters lower-cased. 

## Training

To train a pivot model, use the *train.pl* script in the *bin* directory

````
perl model_dir  train_file  K  lambda  wm  alpha  n_itrs
```
where *K* is the vector size, *lambda* is the regularization parameters, *wm* the missing words weight, and *alpha* used for orthogonal projection (set to 0 to disable). 

For example:

````
perl train.pl pivot_model_dir train_file.txt  100  20  0.01  0  20 
```

The model will be saved in *pivot_model_dir*

### Additional Languages

To train additional models, use *train_xmf.pl* in the *bin* directory:

````
perl train_xmf.pl  pivot_model_dir new_model_dir train_file1 train_file2  K  lambda  wm  alpha  n_itrs
```
where *train_file1* and *train_file2* are parallel sentences in the pivot and new language, respectively. The model for the new language will be saved in *new_model_dir*


## Testing

To use a trained model, use the *test.pl* script in the *bin* directory, which will output one vector per line (corresponding to the input snetences)

````
perl  test.pl  model_dir  test_file
```

To output a similarity score between two sets of vectors, use *get_sim.pl* in *bin/Postprocess*

````
perl get_sim.pl input_file1 input_file2 output_file cutoff
```

Which will output the similarity score between the vectors in *input_file1* and *input_file2*. The cutoff should be set to 1 unless you want to normalize all scores above a certain value. 

*correlation.pl* can be used to calculate the Pearson correlation between two sets of similarity scores. 




