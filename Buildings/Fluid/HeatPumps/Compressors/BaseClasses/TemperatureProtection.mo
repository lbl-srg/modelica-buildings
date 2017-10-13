within Buildings.Fluid.HeatPumps.Compressors.BaseClasses;
model TemperatureProtection
  "Temperature protection for heat pump compressor"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.Temperature TConMax
    "Upper bound for condenser temperature";
  parameter Modelica.SIunits.Temperature TEvaMin
    "Lower bound for evaporator temperature";
  parameter Real dTHys(
    final unit="K",
    min=Modelica.Constants.small) = 5
    "Hysteresis interval width";
  parameter Boolean pre_y_start=false "Value of pre(y) of hysteresis at initial time";

  Modelica.Blocks.Interfaces.RealInput u "Compressor control signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Interfaces.RealInput TEva(
    unit="K",
    displayUnit="degC")
    "Evaporator temperature"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        origin={-120,-80})));
  Modelica.Blocks.Interfaces.RealInput TCon(
    unit="K",
    displayUnit="degC")
    "Condenser temperature" annotation (
     Placement(transformation(
        extent={{-20,-20},{20,20}},
        origin={-120,80})));

  Modelica.Blocks.Interfaces.RealOutput y "Modified compressor control signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Interfaces.BooleanOutput errHigPre
    "Error signal condenser upper bound temperature "
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
  Modelica.Blocks.Interfaces.BooleanOutput errLowPre
    "Error signal evaporator lower bound temperature "
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Modelica.Blocks.Interfaces.BooleanOutput errNegTemDif
    "Error signal if evaporator temperature is above condenser temperature"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
protected
  Modelica.Blocks.Logical.Switch switch
    "Switches control signal off when conditions not satisfied"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Logical.Hysteresis hysHig(uLow=0, uHigh=dTHys,
    final pre_y_start=pre_y_start)
    "Hysteresis for condenser upper bound temperature"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Modelica.Blocks.Sources.Constant zero(final k=0)
    "Zero control signal when check fails"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Modelica.Blocks.Logical.Hysteresis hysLow(uLow=0, uHigh=dTHys,
    final pre_y_start=pre_y_start)
    "Hysteresis for evaporator lower bound temperature"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Blocks.Sources.Constant TMax(final k=TConMax)
    "Condenser maximum temperature"
    annotation (Placement(transformation(extent={{-92,-42},{-80,-30}})));
  Modelica.Blocks.Math.Add dTCon(k2=-1)
    "Difference between condenser temperature and its upper bound"
    annotation (Placement(transformation(extent={{-60,-20},{-40,-40}})));
  Modelica.Blocks.Math.Add dTEva(k1=-1)
    "Difference between evaporator temperature and its lower bound"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Constant TMin(final k=TEvaMin)
    "Evaporator minimum temperature"
    annotation (Placement(transformation(extent={{-92,30},{-80,42}})));
  Modelica.Blocks.MathBoolean.And on(nu=3) "Compressor status"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Modelica.Blocks.Logical.Hysteresis hysdTConEva(
    final uLow=0,
    final uHigh=dTHys,
    final pre_y_start=pre_y_start)
    "Hysteresis for temperature difference between evaporator and condenser"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Math.Add dTEvaCon(final k1=-1)
    "Difference between evaporator and condenser"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.MathBoolean.Not notEva "Negation of signal"
    annotation (Placement(transformation(extent={{64,84},{76,96}})));
  Modelica.Blocks.MathBoolean.Not notdT "Negation of signal"
    annotation (Placement(transformation(extent={{64,64},{76,76}})));
  Modelica.Blocks.MathBoolean.Not notCon "Negation of signal"
    annotation (Placement(transformation(extent={{64,44},{76,56}})));
equation
  connect(zero.y,switch. u3) annotation (Line(points={{41,-30},{50,-30},{50,-8},
          {58,-8}},color={0,0,127}));
  connect(u, switch.u1) annotation (Line(points={{-120,0},{-96,0},{-96,60},{50,
          60},{50,8},{58,8}}, color={0,0,127}));
  connect(switch.y, y)
    annotation (Line(points={{81,0},{110,0}},         color={0,0,127}));
  connect(TMax.y, dTCon.u1) annotation (Line(points={{-79.4,-36},{-79.4,-36},{-62,
          -36}}, color={0,0,127}));
  connect(TMin.y, dTEva.u1) annotation (Line(points={{-79.4,36},{-62,36}},
                color={0,0,127}));
  connect(dTEva.u2, TEva) annotation (Line(points={{-62,24},{-70,24},{-70,-80},
          {-120,-80}},
                    color={0,0,127}));
  connect(dTCon.u2, TCon) annotation (Line(points={{-62,-24},{-76,-24},{-76,80},
          {-120,80}},       color={0,0,127}));
  connect(dTEva.y, hysLow.u)
    annotation (Line(points={{-39,30},{-39,30},{-22,30}}, color={0,0,127}));
  connect(hysHig.u, dTCon.y)
    annotation (Line(points={{-22,-30},{-22,-30},{-39,-30}}, color={0,0,127}));
  connect(on.y, switch.u2)
    annotation (Line(points={{41.5,0},{41.5,0},{58,0}},
                                                    color={255,0,255}));
  connect(dTEvaCon.y, hysdTConEva.u)
    annotation (Line(points={{-39,0},{-32,0},{-22,0}}, color={0,0,127}));
  connect(dTEvaCon.u2, TCon) annotation (Line(points={{-62,-6},{-76,-6},{-76,80},
          {-120,80}},             color={0,0,127}));
  connect(dTEvaCon.u1, TEva) annotation (Line(points={{-62,6},{-70,6},{-70,-80},
          {-120,-80}},     color={0,0,127}));
  connect(hysLow.y, on.u[1]) annotation (Line(points={{1,30},{10,30},{10,4.66667},
          {20,4.66667}},          color={255,0,255}));
  connect(hysdTConEva.y, on.u[2])
    annotation (Line(points={{1,0},{20,0}}, color={255,0,255}));
  connect(hysHig.y, on.u[3]) annotation (Line(points={{1,-30},{14,-30},{14,-4},{
          18,-4},{18,-4.66667},{20,-4.66667}},
                                    color={255,0,255}));
  connect(hysLow.y, notEva.u) annotation (Line(points={{1,30},{10,30},{10,90},{61.6,
          90}}, color={255,0,255}));
  connect(notEva.y, errLowPre)
    annotation (Line(points={{77.2,90},{94,90},{110,90}}, color={255,0,255}));
  connect(notdT.u, hysdTConEva.y) annotation (Line(points={{61.6,70},{12,70},{12,
          0},{1,0}}, color={255,0,255}));
  connect(notdT.y, errNegTemDif)
    annotation (Line(points={{77.2,70},{110,70}}, color={255,0,255}));
  connect(notCon.y, errHigPre)
    annotation (Line(points={{77.2,50},{110,50},{110,50}}, color={255,0,255}));
  connect(notCon.u, hysHig.y) annotation (Line(points={{61.6,50},{14,50},{14,-30},
          {1,-30}}, color={255,0,255}));
  annotation (    Documentation(revisions="<html>
<ul>
<li>
May 30, 2017, by Filip Jorissen:<br/>
First implementation.
See <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/769\">#769</a>.
</li>
</ul>
</html>",
info="<html>
<p>
Temperature protection block for heat pumps.
This block overrides the heat pump control
signal when the condenser temperature is too high,
the evaporator temperature is too low,
or the temperature difference between
the condenser and evaporator is negative.
</p>
<h4>Typical use and important parameters</h4>
<p>
Temperature bounds are set using <code>TConMax</code>
and <code>TEvaMin</code>.
</p>
<h4>Options</h4>
<p>
Parameter <code>dTHys</code> may be used
to change the hysteresis interval.
</p>
</html>"));
end TemperatureProtection;
