%% Behavioral data
% 1. Movie cond 2. math Cond 3. O/X1 4. O/x2 5. interaction
sub1 = [2	2	1	0	4
2	2	1	1	4
2	2	1	1	4
2	2	1	1	4
1	1	1	1	1
1	1	1	1	1
1	1	0	1	1
2	1	0	1	2
1	1	1	0	1
1	2	1	1	3
1	2	1	1	3
2	1	0	1	2
1	2	1	1	3
2	2	1	1	4
1	1	1	0	1
1	1	1	1	1
2	1	1	0	2
1	1	1	1	1
1	2	0	0	3
2	2	1	1	4
1	2	0	1	3
1	1	1	0	1
2	2	1	1	4
1	2	1	1	3
2	2	1	1	4
2	2	1	0	4
2	1	1	1	2
2	1	1	1	2
1	1	1	1	1
2	1	1	0	2];

sub2 = [1	1	1	0	1
2	1	0	0	2
1	1	1	1	1
1	1	1	1	1
2	2	1	1	4
2	2	0	1	4
2	2	1	1	4
2	1	0	0	2
1	2	1	1	3
1	2	1	1	3
2	1	1	1	2
2	1	1	1	2
2	2	1	1	4
1	2	1	0	3
1	1	1	0	1
2	2	0	0	4
2	2	0	1	4
2	2	1	1	4
1	2	0	1	3
1	1	0	0	1
1	1	1	1	1
1	1	1	1	1
2	1	1	1	2
2	2	1	0	4
1	2	1	1	3
2	2	1	1	4
2	1	0	0	2
1	1	1	0	1
1	2	1	1	3
1	1	0	0	1];

%% SETUP: Variables
sub1_cond = [sub1(:,1:2)-1 sub1(:,5)-mean(sub1(:,5))];
sub2_cond = [sub1(:,1:2)-1 sub2(:,5)-mean(sub2(:,5))];

sub1_ans = sum(sub1(:,3:4),2);
sub2_ans = sum(sub2(:,3:4),2);
%%
B1 = glmfit(sub1_cond, [sub1_ans (ones(1,30)'+1)],'binomial','link','probit');
yfit1 = glmval(B1,sub1_cond,'probit','size',(ones(1,30)'+1));
plot(sub1_cond, sub1_ans./(ones(1,30)'+1),'o',sub1_cond,yfit1./(ones(1,30)'+1),'-','LineWidth',2);
B2 = glmfit(sub2_cond, [sub2_ans (ones(1,30)'+1)],'binomial','link','probit');


%%
fitlm(sub1_cond, sub1_ans)
fitlm(sub2_cond, sub2_ans)

