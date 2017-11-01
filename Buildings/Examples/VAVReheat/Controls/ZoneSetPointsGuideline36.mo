within Buildings.Examples.VAVReheat.Controls;
model ZoneSetPointsGuideline36
  extends Modelica.Blocks.Icons.Block;

  parameter Integer numZon(min=2) "Total number of served zones/VAV boxes";
  parameter Modelica.SIunits.Temperature THeaOn=293.15
    "Heating setpoint during on";
  parameter Modelica.SIunits.Temperature THeaOff=285.15
    "Heating setpoint during off";
  parameter Modelica.SIunits.Temperature TCooOff=303.15
    "Cooling setpoint during off";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon[numZon](each final unit=
        "K", each quantity="ThermodynamicTemperature")
    "Measured zone temperatures" annotation (Placement(transformation(rotation=
            0, extent={{-140,-20},{-100,20.5}}), iconTransformation(extent={{
            -140,-20},{-100,20.5}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc(final unit="s",
      quantity="Time") annotation (Placement(transformation(rotation=0, extent={{-140,40},
            {-100,80}}), iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc annotation (Placement(
        transformation(rotation=0, extent={{-140,-100},{-100,-59.5}}),
        iconTransformation(extent={{-140,-100},{-100,-59.5}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TCooSet(final unit="K",
      quantity="ThermodynamicTemperature")
                                          "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{100,90},{120,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaSet(final unit="K",
      quantity="ThermodynamicTemperature") "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.ZoneTemperatures TSetZon(
      have_occSen=false, have_winSen=false)
  "Zone set point temperature"
    annotation (Placement(transformation(extent={{18,-46},{58,-6}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cooDemLimLev(
    k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Constants.DemandLimitLevels.cooling0)
    "Cooling demand limit level"
    annotation (Placement(transformation(extent={{-80,-71},{-60,-51}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant heaDemLimLev(
    k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Constants.DemandLimitLevels.heating0)
    "Heating demand limit level"
    annotation (Placement(transformation(extent={{-80,-101},{-60,-81}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHeaOn(k=THeaOn)
    "Heating on setpoint"
    annotation (Placement(transformation(extent={{-80,81},{-60,101}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHeaOff(
    k=THeaOff) "Heating off set point"
    annotation (Placement(transformation(extent={{-80,51},{-60,71}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooCooOn(k=297.15)
    "Cooling on setpoint"
    annotation (Placement(transformation(extent={{-80,109},{-60,129}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooCooOff(k=
        TCooOff) "Cooling off set point"
    annotation (Placement(transformation(extent={{-80,21},{-60,41}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode
    opeModSel(numZon=numZon) "Operation mode selector"
    annotation (Placement(transformation(extent={{-30,-41},{-10,-21}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant tCooDowHeaUp[numZon](each final
            k=1800) "Cool down and heat up time (assumed as constant)"
    annotation (Placement(transformation(extent={{-80,-11},{-60,9}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yOpeMod "Operation mode"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yFreProSta
    "Freeze protection stage" annotation (Placement(transformation(extent={{100,-50},
            {120,-30}}),        iconTransformation(extent={{100,-60},{120,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant winSta[numZon](
    each k=false)
    "Window status"
    annotation (Placement(transformation(extent={{-32,-90},{-12,-70}})));
equation
  connect(TSetZon.uCooDemLimLev,cooDemLimLev. y) annotation (Line(points={{16,-40},
          {0,-40},{0,-60},{-30,-60},{-30,-61},{-59,-61}},
                                              color={255,127,0}));
  connect(heaDemLimLev.y,TSetZon. uHeaDemLimLev) annotation (Line(points={{-59,-91},
          {6,-91},{6,-90},{6,-44},{16,-44}},   color={255,127,0}));
  connect(TSetZon.occCooSet,TSetRooCooOn. y) annotation (Line(points={{16,-8},{
          2,-8},{2,119},{-59,119}},      color={0,0,127}));
  connect(TSetZon.occHeaSet,TSetRooHeaOn. y) annotation (Line(points={{16,-12},
          {-2,-12},{-2,91},{-59,91}},    color={0,0,127}));
  connect(TSetZon.unoCooSet,TSetRooCooOff. y) annotation (Line(points={{16,-16},
          {-10,-16},{-10,0},{-10,31},{-59,31}},
                                         color={0,0,127}));
  connect(TSetZon.unoHeaSet,TSetRooHeaOff. y) annotation (Line(points={{16,-20},
          {-6,-20},{-6,61},{-59,61}},    color={0,0,127}));
  connect(opeModSel.yOpeMod, TSetZon.uOpeMod) annotation (Line(points={{-9,-31},
          {10,-31},{10,-36},{16,-36}}, color={255,127,0}));
  connect(tCooDowHeaUp.y,opeModSel. cooDowTim) annotation (Line(points={{-59,-1},
          {-52,-1},{-52,-26.6},{-31,-26.6}},     color={0,0,127}));
  connect(tCooDowHeaUp.y,opeModSel. warUpTim) annotation (Line(points={{-59,-1},
          {-52,-1},{-52,-28.8},{-31,-28.8}},     color={0,0,127}));
  connect(TSetRooCooOn.y,opeModSel. TCooSet) annotation (Line(points={{-59,119},
          {-40,119},{-40,-35.6},{-31,-35.6}}, color={0,0,127}));
  connect(opeModSel.THeaSet,TSetRooHeaOn. y) annotation (Line(points={{-31,
          -33.2},{-38,-33.2},{-38,91},{-59,91}},  color={0,0,127}));
  connect(opeModSel.TUnoHeaSet,TSetRooHeaOff. y) annotation (Line(points={{-31,
          -37.8},{-42,-37.8},{-42,61},{-59,61}},color={0,0,127}));
  connect(opeModSel.TUnoCooSet,TSetRooCooOff. y) annotation (Line(points={{-31,-40},
          {-44,-40},{-44,31},{-59,31}},     color={0,0,127}));
  connect(tNexOcc, opeModSel.tNexOcc) annotation (Line(points={{-120,60},{-92,
          60},{-92,-18},{-52,-18},{-52,-12},{-52,-24.4},{-31,-24.4}},
                                              color={0,0,127}));
  connect(uOcc, opeModSel.uOcc) annotation (Line(points={{-120,-79.75},{-78,
          -79.75},{-78,-80},{-36,-80},{-36,-78},{-36,-78},{-36,-22},{-31,-22}},
                               color={255,0,255}));

  connect(TSetZon.TCooSet, TCooSet) annotation (Line(points={{60,-26},{70,-26},
          {70,100},{110,100}},
                             color={0,0,127}));
  connect(TSetZon.THeaSet, THeaSet) annotation (Line(points={{60,-34},{74,-34},
          {74,60},{110,60}},   color={0,0,127}));
  connect(opeModSel.yOpeMod, yOpeMod) annotation (Line(points={{-9,-31},{10,-31},
          {10,-32},{10,-32},{10,-32},{10,-32},{10,-32},{10,-60},{88,-60},{88,0},
          {110,0}}, color={255,127,0}));
  connect(opeModSel.yFreProSta, yFreProSta) annotation (Line(points={{-9,-36},{
          -4,-36},{-4,-64},{92,-64},{92,-40},{110,-40}}, color={255,127,0}));
  connect(winSta.y, opeModSel.uWinSta) annotation (Line(points={{-11,-80},{-8,-80},
          {-8,-52},{-20,-52},{-20,-42}}, color={255,0,255}));
  connect(opeModSel.TZon, TZon) annotation (Line(points={{-31,-31},{-94,-31},{
          -94,0.25},{-120,0.25}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,140}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,140}})));
end ZoneSetPointsGuideline36;
