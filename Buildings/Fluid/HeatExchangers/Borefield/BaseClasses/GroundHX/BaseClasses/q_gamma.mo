within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.GroundHX.BaseClasses;
function q_gamma "subfunction of the error function"
  extends Modelica.Icons.Function;
  input Real a;
  input Real x;
  input Real loggamma_a;
  output Real result;

protected
  Integer k;
  Real w;
  Real temp;
  Real previous;
  Real la;
  Real lb;
  Boolean conv=false "check for convergence";
algorithm
  la :=1;
  lb :=1 + x - a;
  if (x < 1 + a) then
    result :=1 - p_gamma(
      a,
      x,
      loggamma_a);
    conv :=true;
  else
    w :=exp(a*log(x) - x - loggamma_a);
    result :=w/lb;
    k :=2;
    while k<1000 and not conv loop
      temp :=((k - 1 - a)*(lb - la) + (k + x)*lb)/k;
      la :=lb;
      lb :=temp;
      w :=w*(k - 1 - a)/k;
      temp :=w/(la*lb);
      previous :=result;
      result :=result + temp;
      if abs(result - previous) < 0.00001 then
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
end q_gamma;
