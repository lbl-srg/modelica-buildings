within Buildings.Fluid.HeatPumps.Compressors.BaseClasses.Validation;
model TemperatureProtection
  "Validation of temperature protection model"
  import Buildings;
  extends Modelica.Icons.Example;

  Buildings.Fluid.HeatPumps.Compressors.BaseClasses.TemperatureProtection
    temPro(TConMax=313.15, TEvaMin=273.15) "Temperature protection block"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Modelica.Blocks.Sources.Cosine TEva(
    freqHz=1,
    amplitude=10,
    offset=283.15) "Evaporator temperature"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Sources.Cosine TCon(
    freqHz=1.2,
    offset=303.15,
    amplitude=20) "Condenser temperature"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Constant one(k=1) "Control signal"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
protected
  Modelica.Blocks.Logical.Hysteresis hysHig(uLow=0, uHigh=dTHys,
    final pre_y_start=pre_y_start)
    "Hysteresis for condenser upper bound temperature"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Modelica.Blocks.Logical.Hysteresis hysLow(uLow=0, uHigh=dTHys,
    final pre_y_start=pre_y_start)
    "Hysteresis for evaporator lower bound temperature"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Modelica.Blocks.Math.Add dTCon(k2=-1)
    "Difference between condenser temperature and its upper bound"
    annotation (Placement(transformation(extent={{-20,60},{0,40}})));
  Modelica.Blocks.Math.Add dTEva(k1=-1)
    "Difference between evaporator temperature and its lower bound"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Modelica.Blocks.Logical.Hysteresis hysdTConEva(
    uLow=0,
    uHigh=dTHys,
    final pre_y_start=pre_y_start)
    "Hysteresis for temperature difference between evaporator and condenser"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Modelica.Blocks.Math.Add dTEvaCon(k1=-1)
    "Difference between evaporator and condenser"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
equation
  connect(TEva.y, temPro.TEva) annotation (Line(points={{-59,-30},{-40,-30},{
          -40,2},{-22,2}}, color={0,0,127}));
  connect(temPro.TCon, TCon.y) annotation (Line(points={{-22,18},{-40,18},{-40,
          50},{-59,50}}, color={0,0,127}));
  connect(one.y, temPro.u)
    annotation (Line(points={{-59,10},{-40,10},{-22,10}}, color={0,0,127}));
  connect(dTEva.y,hysLow. u)
    annotation (Line(points={{1,-30},{1,-30},{18,-30}},   color={0,0,127}));
  connect(hysHig.u,dTCon. y)
    annotation (Line(points={{18,50},{1,50}},                color={0,0,127}));
  connect(dTEvaCon.y,hysdTConEva. u)
    annotation (Line(points={{1,-70},{8,-70},{18,-70}},color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Model that tests temperature protection functionality.
</p>
</html>"));
end TemperatureProtection;
