function main
    hold on
    fprintf('start\n');

   % option 1
   tab1 = Devoir2(1, [-120*1000/3600 0 4.55*1000/3600]);
    x1 = tab1(:, 5);
    y1 = tab1(:, 6);
    z1 = tab1(:, 7);
    scatter3(x1,y1,z1);
    tab2 = Devoir2(1, [-120*1000/3600 0 7.79*1000/3600]);
    x2 = tab2(:, 5);
    y2 = tab2(:, 6);
    z2 = tab2(:, 7);
   scatter3(x2,y2,z2);
   tab3 = Devoir2(1, [-120*1000/3600 1.8*1000/3600 5.63*1000/3600]);
    x3 = tab3(:, 5);
    y3 = tab3(:, 6);
    z3 = tab3(:, 7);
    scatter3(x3,y3,z3);
    % option 1 end

    % option 2
   tab21 = Devoir2(2, [-120*1000/3600 0 4.55*1000/3600]);
    x21 = tab21(:, 5);
    y21 = tab21(:, 6);
    z21 = tab21(:, 7);
    scatter3(x21,y21,z21);
    tab22 = Devoir2(2, [-120*1000/3600 0 7.79*1000/3600]);
    x22 = tab22(:, 5);
    y22 = tab22(:, 6);
    z22 = tab22(:, 7);
    scatter3(x22,y22,z22);
    tab23 = Devoir2(2, [-120*1000/3600 1.8*1000/3600 5.63*1000/3600]);
    x23 = tab23(:, 5);
    y23 = tab23(:, 6);
    z23 = tab23(:, 7);
    scatter3(x23,y23,z23);
    % option 2 end

   % option 3
   tab31 = Devoir2(3, [-120*1000/3600 0 4.55*1000/3600]);
    x31 = tab31(:, 5);
    y31 = tab31(:, 6);
    z31 = tab31(:, 7);
    scatter3(x31,y31,z31);
    tab32 = Devoir2(3, [-120*1000/3600 0 7.79*1000/3600]);
    x32 = tab32(:, 5);
    y32 = tab32(:, 6);
    z32 = tab32(:, 7);
    scatter3(x32,y32,z32);
   tab33 = Devoir2(3, [-120*1000/3600 1.8*1000/3600 5.63*1000/3600]);
    x33 = tab33(:, 5);
    y33 = tab33(:, 6);
    z33 = tab33(:, 7);
    scatter3(x33,y33,z33);
    % option 3 end

    zp = ZonePrise();
    patch( [0 0 0 0], [zp(3) zp(3) zp(1) zp(1)], [zp(4) zp(2) zp(2) zp(4)], [0.5 0.5 0.5])
    axis([-15 20 -1 1 0 3]); 
end

function y = dt()
    y = 0.1;
end

function y = Pos0()
    y = [18.44 0 2.1];
end

function y = db()
     y = 0.073;
end

function y = mb()
    y = 0.145;
end

function y = ZonePrise()
     y = [-0.1524 0.8 0.1525 1.8];
end

function y = pAir()
    y = 1.1644;
end

function y = Cv()
    y = 1.45
end

function y = w()
    y = [0 0 50];
end

function y = Cm(w)
    norme = norm(w);
    y = 1.6*10^(-3)*norme;
end

function y = Devoir2(option, vi)
    deltaT = dt();
    qSol = zeros(7);
    pos = Pos0();
    qSol(1,:) = [0 vi(1) vi(2) vi(3) pos(1) pos(2) pos(3)];
    i = 1;
result = 0;
    while( i == 1 || result == 0 )
        switch option
            case 1
                qSol(i+1,:) = SEDEuler(qSol(i,:), deltaT, G1(qSol(i,:), deltaT));
             case 2
                qSol(i+1,:) = SEDEuler(qSol(i,:), deltaT, G2(qSol(i,:), deltaT));
             case 3
                 qSol(i+1,:) = SEDEuler(qSol(i,:), deltaT, G3(qSol(i,:), deltaT));
        end
        i = i + 1;
    result = estArrive(qSol(i, :), qSol(i-1,:));
    end
    %qsol(1) est le temps
    % result-1 = 0 si sol, sinon = 1 si prise
    qfinal = zeros(8);
    d = size(qSol);
    i = 1;
    while(i <= d(1))
        qfinal(i,:) = [result-1 qSol(i,2) qSol(i,3) qSol(i,4) qSol(i,5) qSol(i,6) qSol(i,7) qSol(i,1)];
        i = i+1;
    end
    y = qfinal; %[result-1 qSol(:,2) qSol(:,3) qSol(:,4) qSol(:,5) qSol(:,6) qSol(:,7) qSol(:,1)];
end

function y = estArrive(q1, q0)
    zone = ZonePrise();
    rayon = db()/2;
    y=0;
    vitesse = [q1(2) q1(3) q1(4)];
    pos = [q1(5) q1(6) q1(7)];
    if(q1(7) <= 0)
        y=1;
        fprintf('arrive a terre avec t=%f, pos=%s, vitesse=%s,   \n', q1(1), mat2str(pos), mat2str(vitesse));
    else if (q1(5) <= 0 && q0(5) >= 0)
            if(q1(6) - rayon >= zone(1) && q1(6) + rayon <= zone(3))
                if(q1(7) - rayon >= zone(2) && q1(7) + rayon <= zone(4))
                    y =2;
                    fprintf('arrive dans la zone avec t=%f, pos=%s, vitesse=%s,   \n', q1(1), mat2str(pos), mat2str(vitesse));
                end
            end
        end
    end 
end

function qs= SEDEuler (q0 ,Deltat , fonctiong )
    % Solution ED dq/dt= fonctiong (q,t)
    % Methode de Euler
    % qs : vecteur final [tf q(tf )]
    % q0 : vecteur initial [ti q(ti )]
    % Deltat : intervalle de temps
    % fonctiong : membre de droite de ED.
    % Ceci est un m- file de matlab
    % qui retourne [1 dq/dt(ti )]
    qs=q0+ fonctiong* Deltat + [Deltat 0 0 0 0 0 0];
    maxIt = 100;
    nbIt = 1;
    % Extrapolation de Richardson
    while (nbIt < maxIt)
        % Calculer avec plus de precision
        nbIt = nbIt*2;
        DeltatPetit = Deltat/nbIt;
        q2=q0+ fonctiong* DeltatPetit + [DeltatPetit 0 0 0 0 0 0];
        % Determiner le taux d'erreur
        avgsol=(q2+qs)/2.;
        ErrSol=(q2-qs);
        MaxErr=max(abs(ErrSol./avgsol));
        qs = q2;
        % Si le taux d'erreur est acceptable, quitter la boucle
        if(MaxErr < 0.05)
            qs = qs + ErrSol/15.;
            break;
        end
    end
end

function y = G1(q0, deltaT)
    y = [0 0 0 -9.8 q0(2) q0(3) q0(4)];
end

function y = G2(q0, ~)
    norme = norm([q0(2) q0(3) q0(4)]);
    ax = -(((pi*db()*db())/8)*pAir()*Cv()*norme*q0(2))/mb();
    ay = -(((pi*db()*db())/8)*pAir()*Cv()*norme*q0(3))/mb();
    az = -(((pi*db()*db())/8)*pAir()*Cv()*norme*q0(4))/mb() - 9.8;
    y = [0 ax ay az q0(2) q0(3) q0(4)];
end

function y = G3(q0, deltaT)
    v = [q0(2) q0(3) q0(4)]
    normeV = norm(v);
    normeW = norm(w());
    a = (cross((((pi*db()*db())/8)*pAir()*Cm(w())*normeV/normeW*w()),v)/mb()) -(((pi*db()*db())/8)*pAir()*Cv()*normeV*v)/mb();
    y = [0 a(1) a(2) a(3)-9.8 q0(2) q0(3) q0(4)];
end
