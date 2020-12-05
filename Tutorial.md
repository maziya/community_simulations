# **Microbial Community Simulations**
## Using Microbiome Modelling Toolbox (MMT)/mgPipe functions (integrated with COBRAToolbox)
1. *createMultipleSpeciesModel* is the function used to generate a community model. This function can be used to create a community of any size.
2.	Each model should be provided with a name tag. This helps identify which model/organism in the community the reaction belongs to. Tags are added as a prefix ‘M1_HEX’. 
3.	Consider the example of a two-species community, with *Bacteroides thetaiotaomicron* and *Faecalibacterium prausnitzii*. After generating the community model, examine the number of reactions and metabolites in the community compartment ‘[u].’ 

|                       Organism                       | B.thetaiotaomicron     | F.prausnitzii          |                              Community                              |
|:----------------------------------------------------:|------------------------|-----------------------|:-------------------------------------------------------------------:|
| Number of  metabolites                               |          1176          |          833          |                         2327 (1176+833+318)                         |
| Number of  reactions (including  exchange reactions) |          1528          |          1030         |          2876 (1528+1030+318(excluding the sink reactions))         |
| Number of exchange reactions                         | 280 + 3 sink reactions | 150 + 1 sink reaction | 321 (union of exchange reactions, includes 3 common sink reactions) |

4.	Exchange reactions of each model in the community are denoted with a prefix of ‘IEX_,’ whereas the community compartment exchanges are indicated as ‘EX_.’
5.	Set the biomass reactions of both models as the objective functions of the community model. 
6.	Add constraints to the exchange reactions in the community compartment, which mimic the medium components for the growth of the community. By default, all the lower bounds (lb) values for the community exchange reactions will be set to -1000.
7.	In this example, all exchanges are provided with a constraint of -1. The lower bound (lb) of the reactions are typically constrained.
8.	In cases where specific ‘diets’ need to be used as constraints, try the adaptVMHDietToAGORA function suitable for models and diets obtained from AGORA and VMH, respectively. 
9.	In other cases, refer to experimental literature for the best medium components required for the growth of the particular microbe. Also, check [KOMODO](https://komodo.modelseed.org/) from ModelSEED, which will help in identifying the components for different media. 
10.	optimizeCbModel can be used to compute growth rates with FBA, using any LP solver (such as Gurobi, CPLEX) 

[Tutorial](https://github.com/maziya/community_simulations/blob/main/MMT_tutorial.m) for the above two-species community using the MMT functions 

## **SteadyCom**
The algorithm computes community growth as well as the relative abundances of each microbe in a community. 

1.	For SteadyCom, use CPLEX as the LP solver. SteadyCom has three main functions:
    a) creating a community model [createCommModel](https://github.com/maziya/community_simulations/blob/main/createCommModel.m)
    b) to simulate an FBA run [SteadyComCplex](https://github.com/maziya/community_simulations/blob/main/SteadyComCplex.m) and 
    c) for FVA [SteadyComFVACplex](https://github.com/maziya/community_simulations/blob/main/SteadyComFVACplex.m)
2.	Community models generated using SteadyCom follow a slightly different naming convention. 
    a) The community compartment is denoted as ‘(u),’ simple brackets unlike the [u] from MMT
    b) Nametags for the models are *spAbbr* that is provided by the user. It is attached as a suffix. e.g, HEX_BT, where BT is the *spAbbr*.
3.	SteadyCom, by default, sets the biomass reactions of each model as the objective. 
4.	By default, SteadyCom sets the lower bounds (lb) of the community exchange reactions as 0. 
5.	As mentioned in the previous sections, diet or other medium component constraints can be added to the community.
6.	ATP maintenance reaction is the ATP hydrolysis to ADP reaction mostly named **‘ATPM’** in many curated models and **‘DM_atp_c_’** in AGORA models.
7.	FVA can be computed for reactions of interest, as mentioned in the tutorial for isobutanol

[SteadyCom Tutorial](https://github.com/maziya/community_simulations/blob/main/SteadyCom_tutorial.m) for the above two-species community.

## TroubleShooting & Tips
**Growth observed in only one organism in the two-species community or NO community growth**
1. For community medium constraints, try to avoid setting the constraints as -1000 for all exchange reactions in the ‘[u]’ or ‘(u)’ compartment. 
*Tip: Usually, bounds such as -1 or lesser -0.1 will work better*
2.	Test for different diets or media, it is possible that the set of constraints in one diet isn’t allowing for an optimal solution 
3.	Verify if the lower bounds (lb) values of all the non-dietary components are set to zero
4.	Try not to alter the lower bounds (lb) for exchange reactions of the individual model, i.e., allow 'M1_IEX_abc[e]' or 'EX_abc(e)_BT' to remain as -1000.
5.	Check if the lb of the sink reactions is non-zero, i.e., set either as -1000 or -1 or -0.5 (lb should be identical to the lower bounds found in the single model of the organism)
6.	Verify if the objective function is set as the biomass reactions of all models in the community

