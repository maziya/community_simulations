%read model files
M1 = readCbModel('iAH991.xml');
M2 = readCbModel('iFpraus_v_1_0.xml');
modelCell = {M1, M2};
%structure with ATPM and biomass rxn IDs
options = struct();
spBm = {'Biomass_BT_v2';'Biomass_FP'};
spATPM = {'ATPM';'ATPM'};
spAbbr = {'BT';'FP'};
options.spBm = spBm;
options.spATPM = spATPM;
options.spAbbr = spAbbr;
options.sepUtEx = false;

% create model
[modelCom,infoCom,indCom, msg] = createCommModel(modelCell, options);

%setting lower bounds for exchange reactions/ media uptake
modelCom.lb(indCom.EXcom) = -1;

% SteadyCom FBA
[sol,result] = SteadyCom(modelCom,options);
M1growth = result.vBM(1);
M2growth = result.vBM(2);
M1abundance = result.BM(1);
M2abundance = result.BM(2);

%SteadyCom FVA
rxnNameList = {'EX_isobut(u)'};
options.rxnNameList = rxnNameList; 
[minFlux,maxFlux] = SteadyComFVACplex(modelCom,options);
