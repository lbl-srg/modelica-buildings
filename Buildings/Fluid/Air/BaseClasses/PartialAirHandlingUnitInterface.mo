within Buildings.Fluid.Air.BaseClasses;
partial model PartialAirHandlingUnitInterface "Partial model for air handling unit interface"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
      final m1_flow_nominal=dat.nomVal.m1_flow_nominal,
      final m2_flow_nominal=dat.nomVal.m2_flow_nominal);
  extends Buildings.Fluid.Air.BaseClasses.EssentialParameter;


  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,255})}),
      Diagram(coordinateSystem(preserveAspectRatio=false),
        graphics={Text(extent={{54,70},{80,64}},lineColor={0,0,255},
                     textString="Waterside",textStyle={TextStyle.Bold}),
                 Text(extent={{58,-64},{84,-70}},lineColor={0,0,255},
                     textString="Airside",textStyle={TextStyle.Bold})}),
    Documentation(info="<html>
<p>This component describes a base interface for the air handling unit. It contains the performance data and fuild ports. </p>
</html>", revisions="<html>
<ul>
<li>May 12, 2017 by Yangyang Fu:<br>First implementation. </li>
</ul>
</html>"));
end PartialAirHandlingUnitInterface;
