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
  parameter Modelica.SIunits.Time Ti[nCon]=fill(60, nCon)
    "Time constant of integrator block"
    annotation (Dialog(enable=Modelica.Math.BooleanVectors.anyTrue({
      controllerType[i] == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerType[i] == Buildings.Controls.OBC.CDL.Types.SimpleController.PID
      for i in 1:nCon})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHea
    "Heating mode enabled signal" annotation (Placement(transformation(extent={{-160,90},
            {-120,130}}), iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uCoo
    "Cooling mode enabled signal" annotation (Placement(transformation(extent={{-160,70},
            {-120,110}}), iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K", displayUnit="degC")
    "Chilled water supply temperature set-point"
    annotation (Placement(transformation(extent={{-160,-60},{-120,-20}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatTop(
    final unit="K",displayUnit="degC")
    "Chilled water temperature at tank top"
    annotation (Placement(transformation(extent={{-160,-80},{-120,-40}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatBot(
    final unit="K",displayUnit="degC")
    "Chilled water temperature at tank bottom"
    annotation (Placement(transformation(extent={{-160,-100},{-120,-60}}),
       iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatTop(
    final unit="K",displayUnit="degC")
    "Heating water temperature at tank top"
    annotation (Placement(transformation(extent={{-160,0},{-120,40}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatBot(
    final unit="K",displayUnit="degC")
    "Heating water temperature at tank bottom"
    annotation (Placement(transformation(extent={{-160,-20},{-120,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet(
    final unit="K", displayUnit="degC")
    "Heating water supply temperature set-point"
    annotation (Placement(transformation(extent={{-160,20},{-120,60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIsoCon
    "Condenser to ambient loop isolation valve control signal"
    annotation (Placement(transformation(extent={{120,-60},{160,-20}}),
      iconTransformation(extent={{120,-60},{160,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIsoEva
    "Evaporator to ambient loop isolation valve control signal"
    annotation (Placement(
    transformation(extent={{120,-100},{160,-60}}),iconTransformation(
      extent={{120,-100},{160,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHea
    "Enabled signal for heating system"
    annotation (Placement(transformation(extent={{120,60},{160,100}}),
      iconTransformation(extent={{120,60},{160,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yCoo
    "Enabled signal for heating system"
    annotation (Placement(transformation(extent={{120,20},{160,60}}),
      iconTransformation(extent={{120,20},{160,60}})));


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
      extent={{120,-20},{160,20}}), iconTransformation(extent={{120,-20},{160,
            20}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1[nCon]
    "Maximum of output control signals"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
equation
  connect(THeaWatTop, conHotSid.TTop) annotation (Line(points={{-140,20},{-64,20},
          {-64,50},{-12,50}},     color={0,0,127}));
  connect(THeaWatBot, conHotSid.TBot) annotation (Line(points={{-140,0},{-60,0},
          {-60,46},{-12,46}},     color={0,0,127}));
  connect(TChiWatTop, conColSid.TTop) annotation (Line(points={{-140,-60},{-64,-60},
          {-64,-70},{-12,-70}},      color={0,0,127}));
  connect(TChiWatBot, conColSid.TBot) annotation (Line(points={{-140,-80},{-60,-80},
          {-60,-74},{-12,-74}},      color={0,0,127}));
  connect(TChiWatSupSet, conColSid.TSet) annotation (Line(points={{-140,-40},{-60,
          -40},{-60,-66},{-12,-66}}, color={0,0,127}));
  connect(THeaWatSupSet, conHotSid.TSet) annotation (Line(points={{-140,40},{-68,
          40},{-68,54},{-12,54}},     color={0,0,127}));
  connect(conHotSid.yIsoAmb, yIsoCon) annotation (Line(points={{12,44},{100,44},
          {100,-40},{140,-40}},color={0,0,127}));
  connect(conColSid.yIsoAmb, yIsoEva) annotation (Line(points={{12,-76},{100,
          -76},{100,-80},{140,-80}},
                               color={0,0,127}));
  connect(conColSid.yHeaCoo, yCoo) annotation (Line(points={{12,-64},{80,-64},{
          80,40},{140,40}}, color={255,0,255}));
  connect(conHotSid.yHeaCoo, yHea) annotation (Line(points={{12,56},{40,56},{40,
          80},{140,80}}, color={255,0,255}));
  connect(conHotSid.y, max1.u1)
    annotation (Line(points={{12,50},{20,50},{20,6},{28,6}}, color={0,0,127}));
  connect(conColSid.y, max1.u2) annotation (Line(points={{12,-70},{20,-70},{20,-6},
          {28,-6}}, color={0,0,127}));
  connect(max1.y, y)
    annotation (Line(points={{52,0},{140,0}}, color={0,0,127}));
  connect(uHea, conHotSid.uHeaCoo) annotation (Line(points={{-140,110},{-16,110},
          {-16,58},{-12,58}}, color={255,0,255}));
  connect(uCoo, conColSid.uHeaCoo) annotation (Line(points={{-140,90},{-20,90},{
          -20,-62},{-12,-62}}, color={255,0,255}));
  connect(THeaWatSupSet, conColSid.TSetHea) annotation (Line(points={{-140,40},
          {-76,40},{-76,-77},{-12,-77}}, color={0,0,127}));
  connect(THeaWatTop, conColSid.TTopHea) annotation (Line(points={{-140,20},{
          -76,20},{-76,-79},{-12,-79}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
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
