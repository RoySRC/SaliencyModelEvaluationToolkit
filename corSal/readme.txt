The source code implements the saliency model described in the published work:
"Image Saliency Estimation via Random Walk Guided by Informativeness and Latent Signal Correlations",  Jia Li, Shu Fang, Yonghong Tian, Tiejun Huang, Xiaowu Chen, Signal Processing: Image Communication (SPIC), 2015.

This code is provided for research purposed only. If you use this code, please cite our paper.

In case of a problem or a question, please contact: yhtian@pku.edu.cn; jiali@buaa.edu.cn

NOTES:
===========
./demo.m     % the demo script showing the usage of function "genSalMap"
./genSalMap.m  % the function that generates a saliency map

Need the code of Vlfeat and gbvs. They are already included in the "external" folder. 

The saliency map may be slightly different from those reported in the paper, because we randomly select probable distractors. 

