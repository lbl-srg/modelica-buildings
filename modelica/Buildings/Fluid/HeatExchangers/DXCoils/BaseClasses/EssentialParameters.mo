within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
partial block EssentialParameters "A partial block for essential parameters"
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialCondensingGases "Medium model"
     annotation (choicesAllMatching=true);
  parameter Buildings.Fluid.HeatExchangers.DXCoils.Data.CoilData datCoi
    "Performance data";
protected
  parameter Integer nSpe=datCoi.nSpe "Number of standard compressor speeds";
  annotation (Diagram(graphics), Documentation(info="<html>
<p>
This partial block is a set of basic parameters required for most of the blocks and models of 
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
