%read the model files and store in array
M1 = readCbModel('iAH991.xml');
M2 = readCbModel('iFpraus_v_1_0.xml');
models{1,1} = M1;
models{2,1} = M2;

%name tags for each model
nameTagsModels{1,1} = 'M1_';
nameTagsModels{2,1} = 'M2_';

%generate a community model
[modelCom] = createMultipleSpeciesModel(models, 'nameTagsModels', nameTagsModels);
[infoCom, indCom] = getMultiSpeciesModelId(modelCom, nameTagsModels);

modelCom.infoCom = infoCom(:);
modelCom.indCom = indCom(:);

%understanding the number of metabolites, reactions in the community model
M1_ex = printUptakeBound(M1);
M1_exs = M1.rxns(M1_ex);  %exchange rxns in M1 including sink rxns
M2_ex = printUptakeBound(M2);
M2_exs = M2.rxns(M2_ex);  %exchange rxns in M2 including sink rxns
common_ex = union(M1_exs,M2_exs); %common exchange and sink rxns
M1_unique = setdiff(M1_exs,M2_exs); % exchange rxns unique to M1
M2_unique = setdiff(M2_exs,M1_exs); % exchange rxns unique to M2

%set biomass rxns of the models as objective functions
M1Biomass=find(ismember(modelCom.rxns, 'M1_Biomass_BT_v2')); 
modelCom.c(M1Biomass,1)=1;
M2Biomass=find(ismember(modelCom.rxns, 'M2_Biomass_FP'));
modelCom.c(M2Biomass,1)=1;

%set medium uptake constraints
modelCom.lb(indCom.EXcom) = -1000;

%FBA 
sol = optimizeCbModel(modelCom,'max');
%observe growth rate for community and individual model
Commgrowth = sol.f;
M1growth = sol.x(M1Biomass);
M2growth = sol.x(M2Biomass);
