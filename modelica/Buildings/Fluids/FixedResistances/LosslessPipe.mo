model LosslessPipe "Pipe with no flow friction and no heat transfer" 
  extends Modelica_Fluid.Interfaces.PartialTwoPortTransport(final dp=0);
  extends Buildings.BaseClasses.BaseIcon;
  annotation (Icon(
      Rectangle(extent=[-100,60; 100,-60],   style(
          color=0,
          gradient=2,
          fillColor=8)),
      Rectangle(extent=[-100,50; 100,-48],   style(
          color=69,
          gradient=2,
          fillColor=69)),
         Text(
        extent=[-104,-50; 18,-116],
        style(color=3, rgbcolor={0,0,255}),
        string="dp0=0")),
    Documentation(info="<html>
<p>
Model of a pipe with no flow resistance and no heat loss.
This model can be used to replace a <tt>replaceable</tt> pipe model
in flow legs in which no friction should be modeled, such as
in the outlet port of a three way valve.
</p>
</html>"),
revisions="<html>
<ul>
<li>
June 13, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>");
end LosslessPipe;
