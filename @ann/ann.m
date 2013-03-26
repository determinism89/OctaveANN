## -*- texinfo -*-
## @deftypefn {Function File} ann()
## @deftypefnx {Function File} ann(@var{nodelist})
## @deftypefnx {Function File} ann(@var{ANN_obj})
## 
## Create an ann object.
## Arguments may be either an existing @var{ANN} object or a list of the nodes @var{nodelist} in the @var{ANN} object may be specified. Alternatively, no argument may be specified - in which case the constructor reduces the ann object to a simple weighted logistic function.
## 
## @end deftypefn

function Obj = ann(A)
	if nargin == 0 %no arguments
		A = [1,1]; %default to simple weighted IO
	endif
	if isa(A,'ann') 
		Obj = A;
	elseif isreal(A) 
		if (size(A,1)==1 || size(A,2)==1) && length(A)>1
			if size(A,1) == 1
				Obj.nodelist = A;
			else
				Obj.nodelist = A';
			endif
			for indx = [2:length(Obj.nodelist)]
				Obj.__W{1,indx-1} = sparse(rand(Obj.nodelist(indx),Obj.nodelist(indx-1)));
				%Obj.__W{1,indx-1} = Obj.__W{1,indx-1}/(10*norm(Obj.__W{1,indx-1}));
				Obj.__DeltaW0{1,indx-1} = zeros(Obj.nodelist(indx),Obj.nodelist(indx-1));
				Obj.__B{indx-1} = sparse(rand(Obj.nodelist(indx),1)); %offset
				Obj.__DeltaB0{indx-1} = zeros(Obj.nodelist(indx),1); %offset
			endfor
		else
			error('ann: nodelist must be a vector argument of DIM > 1 containing the number of nodes in each layer')
		endif
	else
		print_usage();
	endif
	
	%------------------------------------
			%Default Properties
	%------------------------------------
	Obj.alpha = .5;	%learning rate
	Obj.eta = 1;	%Logistic function parameter (slope)
	Obj.lambda = .0001;
	Obj.Graphics = [0;0];
	Obj.TrainingMethod = "Stochastic";
	%------------------------------------
	
	%------------------------------------
			%Instantiated properties
	%------------------------------------
	Obj.__Epoch = 1;
	Obj.__NumLayers = length(Obj.nodelist);
	Obj.__Z=cell(1,Obj.__NumLayers); %node values?
	Obj.__A=cell(1,Obj.__NumLayers); %f(Z)
	Obj.__DeltaW1 = Obj.__DeltaW0;
	Obj.__DeltaW2 = Obj.__DeltaW0;
	Obj.__DeltaB1 = Obj.__DeltaB0; %offset
	Obj.__DeltaB2 = Obj.__DeltaB0; %offset
	Obj.__Err=cell(1,Obj.__NumLayers); %f(Z)
	Obj.__Wsumsqr=[];
	Obj.__j=[]; % cost accumulated over one training sample
	Obj.__J=[0,0]; % cost accumulated over one iteration
	%------------------------------------
	
	Obj = class(Obj,'ann');
endfunction