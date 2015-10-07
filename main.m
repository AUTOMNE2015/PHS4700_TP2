% Main function.
function main

   Devoir2(1, [-120 0 4.55]);
end

function y = dt()
    y = 1;
end
function y = Pos0()
	y = [-18.44 0 2.1];
end

function y = db()
     y = 0.0073;
end

function y = mb()
    y = 0.145;
end

function y = ZonePrise()
     y = [-15.24 0.8 15.25 1.8];
end

function y = Devoir2(option, vi)
    deltaT = dt();
    qSol = zeros(7);
    pos = Pos0();
    qSol(1,:) = [0 vi(1) vi(2) vi(3) pos(1) pos(2) pos(3)];
    i = 1;
    while( i == 1 || estArrive(qSol(i, :), qSol(i-1,:)) == 0)
        switch option
            case 1
                qSol(i+1,:) = SEDEuler(qSol(i,:), deltaT, G1(qSol(i,:), deltaT));
             case 2
                qSol(i+1,:) = SEDEuler(qSol(i,:), deltaT, G2(qSol(i,:), deltaT));
             case 3
                 qSol(i+1,:) = SEDEuler(qSol(i,:), deltaT, G3(qSol(i,:), deltaT));
        end
        i = i + 1;
    end
end

function y = estArrive(q1, q0)
    zone = ZonePrise();
    rayon = db()/2;
    y=0;
    
    if(q1(7) <= 0)
        y=1;
    else if (q1(5) <= 0 && q0(5) >= 0)
            if(q1(6) - rayon >= zone(1) && q1(6) + rayon <= zone(3))
                if(q1(7) - rayon >= zone(2) && q1(7) + rayon <= zone(4))
                    y =1;
                end
            end
        end
    end 
end

function qs= SEDEuler (q0 ,Deltat , fonctiong )
    %
    % Solution ED dq/dt= fonctiong (q,t)
    % Methode de Euler
    % qs : vecteur final [tf q(tf )]
    % q0 : vecteur initial [ti q(ti )]
    % Deltat : intervalle de temps
    % fonctiong : membre de droite de ED.
    % Ceci est un m- file de matlab
    % qui retourne [1 dq/dt(ti )]
    %
    qs=q0+ fonctiong * Deltat ;
end

function y = G1(q0, deltaT)
    y = [q0(1)+deltaT 0 0 -9.8 q0(2) q0(3) q0(4)];
end
function y = G2(q0, deltaT)
    y = [q0(1)+deltaT 0 0 -9.8 q0(2) q0(3) q0(4)];
end
function y = G3(q0, deltaT)
    y = [q0(1)+deltaT 0 0 -9.8 q0(2) q0(3) q0(4)];
end