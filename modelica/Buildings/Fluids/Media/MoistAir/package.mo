package MoistAir 
  extends Modelica.Media.Air.MoistAir(
      mediumName="MoistAir");
  import SI = Modelica.SIunits;


  annotation (Documentation(info="<HTML>
<p>
This is a medium model that is identical to <tt>Modelica.Media.Air.MoistAir</tt>but it adds additional psychrometric functions used for example to obtain the wet bulb temperature.
</p>
</HTML>", revisions="<html>
<ul>
<li>
May 5, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

end MoistAir;
