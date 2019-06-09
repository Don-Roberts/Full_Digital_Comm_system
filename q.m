function answer = Q(x)

% Q function based in N.C. Beaulieu, "A Simple Series for
% Personal Computer Computation of the Error Function Q()",
% IEEE Trans on Comm Vol. 37 No. 9 pp 989-991 Sept. 1989


% Mike Buehrer 
% Feb 1 1995

%for i = 1:length(x)
%	if(x (i) >7) x(i) =7 ;
%	end
%end

x = x + 1e-10;

NEGATIVEFLAG = 0;
MIXEDFLAG = 0;

if max(x) < 0
	NEGATIVEFLAG = 1;
	x = -1*x;
end

if max(x) >= 0 & min(x) < 0
	MIXEDFLAG = 1;
	NFLAG = zeros(1,length(x));
	for i=1:length(x)
		if x(i) < 0
			x(i) = -1*x(i);
			NFLAG(i) = 1;
		end
	end
end


t = 28;
temp = 0.5;
omega = 2*pi/t;

for i=0:16
	n=2*i+1;
	temp = temp - 2*exp(-0.5*n^2*omega^2)*sin(n*x*omega)/(pi*n);
end


temp2 = ones(size(x,1),size(x,2))./(sqrt(2*pi)*x).*exp(-0.5*x.*x);
	

answer = min(abs(temp),abs(temp2));

if NEGATIVEFLAG
	answer = 1 - answer;
end

if MIXEDFLAG 
	for i=1:length(x)
		if NFLAG(i) 
			answer(i) = 1-answer(i);
		end
	end
end