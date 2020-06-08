within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
model Supervisory "Energy transfer station supervisory controller"
  extends Modelica.Blocks.Icons.Block;

  parameter Integer nCon = 1
    "Number of controllers in sequence for ambient sources"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.TemperatureDifference dTHys = 1
    "Temperature hysteresis (absolute value)";
  parameter Modelica.SIunits.TemperatureDifference dTDea = 1
    "Temperature dead band (absolute value)";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType[nCon]=
    fill(Buildings.Controls.OBC.CDL.Types.SimpleController.P, nCon)
    "Type of controller";
  parameter Real k[nCon](each min=0) = fill(1, nCon)
    "Gain of controller";
  parameter Modelica.SIunits.Time Ti[nCon](
    each min=Buildings.Controls.OBC.CDL.Constants.small) = fill(0.5, nCon)
    "Time constant of integrator block"
    annotation (Dialog(enable=Modelica.Math.BooleanVectors.anyTrue({
      controllerType[i] == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerType[i] == Buildings.Controls.OBC.CDL.Types.SimpleController.PID
      for i in 1:nCon})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K", displayUnit="degC")
    "Chilled water supply temperature set-point"
    annotation (Placement(transformation(extent={{-140,-30},{-100,10}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatTop(
    final unit="K",displayUnit="degC")
    "Chilled water temperature at tank top"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatBot(
    final unit="K",displayUnit="degC")
    "Chilled water temperature at tank bottom"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatTop(
    final unit="K",displayUnit="degC")
    "Heating water temperature at tank top"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatBot(
    final unit="K",displayUnit="degC")
    "Heating water temperature at tank bottom"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet(
    final unit="K", displayUnit="degC")
    "Heating water supply temperature set-point"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIsoCon
    "Condenser to ambient loop isolation valve control signal"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIsoEva
    "Evaporator to ambient loop isolation valve control signal"
    annotation (Placement(
    transformation(extent={{100,-100},{140,-60}}),iconTransformation(
      extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHea
    "Enabled signal for heating system"
    annotation (Placement(transformation(extent={{100,60},{140,100}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yCoo
    "Enabled signal for heating system"
    annotation (Placement(transformation(extent={{100,20},{140,60}}),
      iconTransformation(extent={{100,20},{140,60}})));
  HotSide conHotSid(
    final dTHys=dTHys,
    final dTDea=dTDea,
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti)
    "Hot side controller"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  ColdSide conColSid(
    final dTHys=dTHys,
    final dTDea=dTDea,
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti)
    "Cold side controller"
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y[nCon](unit="1")
    "Control output for ambient sources"
    annotation (Placement(transformation(
      extent={{100,-20},{140,20}}), iconTransformation(extent={{100,-20},{140,
            20}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1[nCon]
    "Maximum of output control signals"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
equation
  connect(THeaWatTop, conHotSid.TTop) annotation (Line(points={{-120,50},{-20,50},
          {-20,50},{-12,50}},     color={0,0,127}));
  connect(THeaWatBot, conHotSid.TBot) annotation (Line(points={{-120,20},{-20,
          20},{-20,44},{-12,44}}, color={0,0,127}));
  connect(TChiWatTop, conColSid.TTop) annotation (Line(points={{-120,-40},{-24,-40},
          {-24,-70},{-12,-70}},      color={0,0,127}));
  connect(TChiWatBot, conColSid.TBot) annotation (Line(points={{-120,-70},{-28,
          -70},{-28,-76},{-12,-76}}, color={0,0,127}));
  connect(TChiWatSupSet, conColSid.TSet) annotation (Line(points={{-120,-10},{-20,
          -10},{-20,-64},{-12,-64}}, color={0,0,127}));
  connect(THeaWatSupSet, conHotSid.TSet) annotation (Line(points={{-120,80},{
          -20,80},{-20,56},{-12,56}}, color={0,0,127}));
  connect(conHotSid.yIsoAmb, yIsoCon) annotation (Line(points={{12,44},{80,44},
          {80,-40},{120,-40}}, color={0,0,127}));
  connect(conColSid.yIsoAmb, yIsoEva) annotation (Line(points={{12,-76},{80,-76},
          {80,-80},{120,-80}}, color={0,0,127}));
  connect(conColSid.yHeaCoo, yCoo) annotation (Line(points={{12,-64},{60,-64},{
          60,40},{120,40}}, color={255,0,255}));
  connect(conHotSid.yHeaCoo, yHea) annotation (Line(points={{12,56},{20,56},{20,
          80},{120,80}}, color={255,0,255}));
  connect(conHotSid.y, max1.u1)
    annotation (Line(points={{12,50},{20,50},{20,6},{28,6}}, color={0,0,127}));
  connect(conColSid.y, max1.u2) annotation (Line(points={{12,-70},{20,-70},{20,-6},
          {28,-6}}, color={0,0,127}));
  connect(max1.y, y)
    annotation (Line(points={{52,0},{120,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
        defaultComponentName="conSup",
        Documentation(info="<html>
<p>
The block implements the control sequence for the ETS chilled water and 
heating water circuits.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 10, 2019, by Hagar Elarga:<br/>
Added the documentation. 
</li>
<li>
November 25, 2019, by Hagar Elarga:<br/>
Removed the tank minimum charging flow signal because the primary pumps are constant speed.
</li>
</ul>
</html>"));
end Supervisory;
