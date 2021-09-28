within Buildings.Templates.Interfaces;
partial model Pump
  extends PumpOrValve;

  parameter Types.Pump typ "Type of pump"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  replaceable parameter Fluid.Movers.Data.Generic per(pressure(
    V_flow=m_flow_nominal/1000 .* {0,1,2},
    dp=dp_nominal .* {1.5,1,0.5}))
    constrainedby Fluid.Movers.Data.Generic
    "Performance data"
    annotation (
      choicesAllMatching=true,
      Dialog(enable=typ <> Types.Pump.None),
      Placement(transformation(extent={{-90,-88},{-70,-68}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

end Pump;
