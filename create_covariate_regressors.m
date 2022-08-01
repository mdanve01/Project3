% enter the values in subject order
young.iq = [118 128 114 119 110 113 128 126 125 118 116 113 118 113 117 107 125 111 114 123 118 105];
old.iq = [106 113 100 120 118 119 122 107 122 119 115 113 121 114];
young.sex = [1 1 1 1 1 2 2 2 2 1 2 1 1 1 2 1 1 2 1 2 2 2];
old.sex = [2 2 2 1 1 1 1 2 2 2 2 2 1 2];
% create a duplicate
young.iq2 = young.iq;
old.iq2 = old.iq;
young.sex2 = young.sex;
old.sex2 = old.sex;

% cycle through 11 times adding the vector to itself, to bring a total of
% 12 iterations ina  row (number of conditions per age group)
for n = 1:11;
    young.iq2 = [young.iq2 young.iq];
    young.sex2 = [young.sex2 young.sex];
    old.iq2 = [old.iq2 old.iq];
    old.sex2 = [old.sex2 old.sex];
end

% add young to old and save as a new variable for each covariate
iq = [old.iq2 young.iq2];
sex = [old.sex2 young.sex2];
