within Buildings.Templates.Components.Sensors.Interfaces;
partial model PartialSensor
  extends Buildings.Fluid.Interfaces.PartialTwoPort;

  parameter Boolean have_sen=true
    "Set to true for sensor, false for direct pass through"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Location loc
    "Equipment location"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean isDifPreSen=false
    "Set to true for differential pressure sensor, false for any other sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    if have_sen and not isDifPreSen then (
      if loc ==Buildings.Templates.Components.Types.Location.Supply
                                                then
        dat.getReal(varName=id + ".Mechanical.Supply air mass flow rate.value")
      elseif loc ==Buildings.Templates.Components.Types.Location.OutdoorAir
                                                        then
        dat.getReal(varName=id + ".Mechanical.Supply air mass flow rate.value")
      elseif loc ==Buildings.Templates.Components.Types.Location.MinimumOutdoorAir
                                                               then
        dat.getReal(varName=id + ".Mechanical.Supply air mass flow rate.value")
      elseif loc ==Buildings.Templates.Components.Types.Location.Return
                                                    then
        dat.getReal(varName=id + ".Mechanical.Return air mass flow rate.value")
      elseif loc ==Buildings.Templates.Components.Types.Location.Relief
                                                    then
        dat.getReal(varName=id + ".Mechanical.Return air mass flow rate.value")
      elseif loc ==Buildings.Templates.Components.Types.Location.Terminal
                                                      then
        dat.getReal(varName=id + ".Mechanical.Discharge air mass flow rate.value")
      else 0)
      else 0
    "Mass flow rate"
    annotation (
     Dialog(group="Nominal condition", enable=have_sen and not isDifPreSen));

  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  Controls.OBC.CDL.Interfaces.RealOutput y if have_sen
    "Connector for measured value"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,120})));

equation
  if isDifPreSen and (not have_sen) then
    // Zero flow equations for connectors
    port_a.m_flow = 0;
    port_b.m_flow = 0;

    // No contribution of specific quantities
    port_a.h_outflow = 0;
    port_b.h_outflow = 0;
    port_a.Xi_outflow = zeros(Medium.nXi);
    port_b.Xi_outflow = zeros(Medium.nXi);
    port_a.C_outflow  = zeros(Medium.nC);
    port_b.C_outflow  = zeros(Medium.nC);
  end if;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                                              Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
      Rectangle(
        visible=(not have_sen) and (not isDifPreSen),
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
The location parameter <code>loc</code> is used to assign nominal parameter values
based on the external system parameter file.
</p>
</html>"));
end PartialSensor;
