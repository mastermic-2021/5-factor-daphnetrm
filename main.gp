encode(m)=fromdigits(Vec(Vecsmall(m)),128);
[n,c] = readvec("input.txt");
decode(m)=Strchr(digits(m, 128));



\\ Il faut trouver p et q tq n=p*q pour pouvoir déchiffrer m.
\\ Pour cela, on peut utiliser la méthode rho de Pollard,
\\ inspirée de la demo faite en cours.
factor_pollard(n) = {
	x=Mod(1,n);
	y=Mod(1,n);
	g=1;
	while(g==1, 
		x=x^2+1; 
		y=y^2+1;
		y=y^2+1;
		g=gcd(x-y,n));
	g;
};

\\ La méthode précédente est trop lente, on essaye autre chose :
\\ (également montrée en cours)
\\ Cette fois, on tente la méthode p-1, ce qui convient car
\\ n n'est composé que de deux facteurs.
factor_pollard_bis(n)={
	k=1;
	a=Mod(3,n);
	g=1;
	while(g==1,
		a=a^k;
		g=gcd(lift(a-1),n); k=k+1);
	g; 
};



\\ Le symbole de Jacobi et la parité du message permette de retrouver le clair
\\ C'est ce que l'on applique avec cette fonction.
dechiffre(m, p, q) = {
	    \\ on récupère m² mod n
	    c=Mod(m[1],n);
	    \\ puis le symbole et la parité;
	    j=m[2];
	    par=m[3];
	    \\ applique la méthode de déchiffrement :
	    m_p = c^((p+1)/4); \\ m mod p
	    m_q = c^((q+1)/4); \\ m mod q
	    \\ On résout avec le lemme chinois !
	    \\ Pour cela, on retrouve la relation de Bézout qui lie p et q.
	    b=gcdext(p, q);
	    u = b[1];
	    v = b[2];
	    s = n - m_q*u*p + m_p*v*q;
	    \\ On n'oublie pas de quitter les congruences.
	    lift(s);
};


\\ on détermine un facteur de n via la méthode de Pollard
p=factor_pollard_bis(n);
\\ puis le second facteur
q=n/p;
\\ on déchiffre
d=dechiffre(c, p, q);
\\ et on décode de manière à avoir un texte lisible
print(decode(d));