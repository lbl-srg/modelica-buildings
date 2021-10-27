within Buildings.Templates.Interfaces;
partial model Pump
  extends Fluid.Interfaces.PartialTwoPort(
    redeclare package Medium=Buildings.Media.Water);

  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  Buildings.Templates.BaseClasses.Connectors.BusInterface busCon "Control bus"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  parameter Types.Pump typ "Type of pump"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Templates.Types.PumpLocation loc
    "Pump location"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    if typ <> Types.Pump.None then (
      if loc == Templates.Types.PumpLocation.CHWHeadered then
        dat.getReal(varName=id + ".Mechanical.Headered PCHWP mass flow rate.value")
      elseif loc == Templates.Types.PumpLocation.CHWDedicated then
        dat.getReal(varName=id + ".Mechanical.Dedicated PCHWP mass flow rate.value")
      elseif loc == Templates.Types.PumpLocation.CHWSecondary then
        dat.getReal(varName=id + ".Mechanical.SCHWP mass flow rate.value")
      elseif loc == Templates.Types.PumpLocation.CWHeadered then
        dat.getReal(varName=id + ".Mechanical.Headered CWP mass flow rate.value")
      elseif loc == Templates.Types.PumpLocation.CWDedicated then
        dat.getReal(varName=id + ".Mechanical.Dedicated CWP mass flow rate.value")
      else 0)
      else 0
    "Mass flow rate"
    annotation (Dialog(group="Nominal condition",
      enable=typ <> Types.Pump.None));

   parameter Modelica.SIunits.PressureDifference dp_nominal=
     if typ <> Types.Pump.None then (
      if loc == Templates.Types.PumpLocation.CHWHeadered then
        dat.getReal(varName=id + ".Mechanical.Headered PCHWP pressure rise.value")
      elseif loc == Templates.Types.PumpLocation.CHWDedicated then
        dat.getReal(varName=id + ".Mechanical.Dedicated PCHWP pressure rise.value")
      elseif loc == Templates.Types.PumpLocation.CHWSecondary then
        dat.getReal(varName=id + ".Mechanical.SCHWP pressure rise.value")
      elseif loc == Templates.Types.PumpLocation.CWHeadered then
        dat.getReal(varName=id + ".Mechanical.Headered CWP pressure rise.value")
      elseif loc == Templates.Types.PumpLocation.CWDedicated then
        dat.getReal(varName=id + ".Mechanical.Dedicated CWP pressure rise.value")
      else 0)
      else 0
    "Total pressure rise"
    annotation (Dialog(group="Nominal condition",
      enable=typ <> Types.Pump.None));

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
