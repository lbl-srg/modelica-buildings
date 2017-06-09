within Buildings.Fluid.Air.BaseClasses;
partial model PartialAirHandlingUnitInterface "Partial model for air handling unit interface"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
      final m1_flow_nominal=dat.nomVal.m1_flow_nominal,
      final m2_flow_nominal=dat.nomVal.m2_flow_nominal);
  extends Buildings.Fluid.Air.BaseClasses.EssentialParameter;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,255}),
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
      Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This component describes a base interface for the air handling unit.
It contains the performance data and fluid ports.
</p>
</html>", revisions="<html>
<ul>
<li>
May 12, 2017 by Yangyang Fu:<br/>
First implementation. 
</li>
</ul>
</html>"));
end PartialAirHandlingUnitInterface;
