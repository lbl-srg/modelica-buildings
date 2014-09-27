within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.GroundHX.BaseClasses;
function p_gamma "subfunction of the error function"
  extends Modelica.Icons.Function;
  input Real a;
  input Real x;
  input Real loggamma_a;
  output Real result;

protected
  Integer k;
  Real term;
  Real previous;
  Boolean conv = false "check for convergence";

algorithm
    if (x >= 1 + a) then
       result :=1 - q_gamma(
      a,
      x,
      loggamma_a);
       conv :=true;
    elseif x == 0 then
      result :=0;
      conv :=true;
    else
      result :=exp(a*log(x) - x - loggamma_a)/a;
      term :=result;
      k :=1;
      while k < 1000 and not conv loop
        term :=term*x/(a + k);
        previous :=result;
        result :=result + term;
        if abs(result - previous) < 0.0000001 then
          conv :=true;
        else
          k :=k + 1;
        end if;
      end while;
    end if;
  assert(conv,"the q_gamma function of erf could not converge");

  annotation (Documentation(info="<html>
  <p>Subfunction of the error function according to the c-implementation of Haruhiko Okumura. </p>
<h4>References</h4>
<p>
Haruhiko Okumura: <i>C-gengo niyoru saishin algorithm jiten </i>
            (New Algorithm handbook in C language) (Gijyutsu hyouron
            sha, Tokyo, 1991) p.227 [in Japanese] .
</p>
</html>", revisions="<html>
<ul>
<li>
September 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end p_gamma;
