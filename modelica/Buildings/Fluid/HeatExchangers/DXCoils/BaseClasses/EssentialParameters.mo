within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
partial block EssentialParameters "A partial block for essential parameters"
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialCondensingGases "Medium model"
     annotation (choicesAllMatching=true);
  parameter Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.DXCoil
                                                                 datCoi
    "Performance data"
    annotation (Placement(transformation(extent={{-80,82},{-68,94}})));
protected
  parameter Integer nSta=datCoi.nSta "Number of stages";
  annotation (Diagram(graphics), Documentation(info="<html>
<p>
This partial block declares parameters that are required by most classes
in the package
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils\"> 
Buildings.Fluid.HeatExchangers.DXCoils</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 1, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"));
end EssentialParameters;
