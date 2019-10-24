within Buildings.Fluid.HeatExchangers.CoolingTowers.Validation;
model MerkelEnergyPlus
  "Validation model for variable speed cooling tower based on Merkel's theory"
  extends Modelica.Icons.Example;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model validates the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel\">
Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 23, 2019 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end MerkelEnergyPlus;
