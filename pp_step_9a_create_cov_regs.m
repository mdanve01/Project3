clear all
iq.old = [106 113 100 120 118 119 122 107 122 119 115 113 121 120 114 116 121 107 119 114 116 123 118 108];
iq.young = [118 128 114 119 110 113 128 126 125 118 113 118 113 117 107 125 111 114 123 100 118 105 117 130];
gender.old = [2 2 2 1 1 1 1 2 2 2 2 2 1 1 2 1 2 2 2 2 2 1 1 2];
gender.young = [1 1 1 1 1 2 2 2 2 1 1 1 1 2 1 1 2 1 2 2 2 2 1 2];
% this is set to cases where n-1 is only ever correct
num_trials.old = [2.67 7.50 9.75 9.00 9.50 4.00 5.33 6.75 7.25 4.75 9.50 4.00 9.00 5.33 7.00 3.25 9.00 7.00 3.25 5.25 4.00 8.75 8.00 5.50];
num_trials.young = [11.25 5.25 7.50 9.50 8.50 11.25 9.50 10.25 8.00 10.00 10.00 10.00 9.75 9.75 2.75 10.75 9.75 9.00 10.25 9.00 6.00 9.50 10.50 10.50];

iq.old_orig = iq.old;
iq.young_orig = iq.young;
gender.old_orig = gender.old;
gender.young_orig = gender.young;
num_trials.old_orig = num_trials.old;
num_trials.young_orig = num_trials.young;

for n = 1:11;
    iq.old_orig = [iq.old_orig iq.old];
    gender.old_orig = [gender.old_orig gender.old];
    num_trials.old_orig = [num_trials.old_orig num_trials.old];
    iq.young_orig = [iq.young_orig iq.young];
    gender.young_orig = [gender.young_orig gender.young];
    num_trials.young_orig = [num_trials.young_orig num_trials.young];
end

iq.all = [iq.old_orig iq.young_orig]';
gender.all = [gender.old_orig gender.young_orig]';
num_trials.all = [num_trials.old_orig num_trials.young_orig]';

