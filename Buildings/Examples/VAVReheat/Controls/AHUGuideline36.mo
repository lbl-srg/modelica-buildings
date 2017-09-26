within Buildings.Examples.VAVReheat.Controls;
model AHUGuideline36
  import Buildings;
  extends Modelica.Blocks.Icons.Block;
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.SetPoints.VAVSupplyFan
    conSupFan(numZon=numZon)
              annotation (Placement(transformation(extent={{-51,40},{-31,60}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.SetPoints.VAVSupplyTemperature
    supTemSetMulVAV
    annotation (Placement(transformation(extent={{35,-54},{55,-34}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.SetPoints.OutsideAirFlow
    outAirSetPoi_MulZon(
    zonAre=zonAre,
    occSen=fill(false, numOfZon),
    maxSysPriFlo=maxSysPriFlo,
    minZonPriFlo=minZonPriFlo)
    annotation (Placement(transformation(extent={{-51,10},{-31,30}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.SetPoints.ReliefDamper
    relDam annotation (Placement(transformation(extent={{-1,-32},{19,-12}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.Economizers.Controller
    conEco1 annotation (Placement(transformation(extent={{35,10},{55,30}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "System operation mode"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonPreResReq1
    "Zone static pressure reset requests"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
  parameter Integer numZon "Total number of served zones/VAV boxes";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ducStaPre(unit="Pa")
    "Measured duct static pressure"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  parameter Modelica.SIunits.VolumeFlowRate maxSysPriFlo
    "Maximum expected system primary airflow at design stage";
  parameter Modelica.SIunits.VolumeFlowRate minZonPriFlo[numOfZon]
    "Minimum expected zone primary flow rate";
  parameter Modelica.SIunits.Area zonAre[numOfZon] "Area of each zone";
equation
  connect(conSupFan.uOpeMod, uOpeMod) annotation (Line(points={{-53,58},{-80,58},
          {-80,80},{-120,80}}, color={255,127,0}));
  connect(conSupFan.uZonPreResReq, uZonPreResReq1) annotation (Line(points={{
          -53,47},{-120,47},{-120,50}}, color={255,127,0}));
  connect(conSupFan.ducStaPre, ducStaPre) annotation (Line(points={{-53,42},{
          -78,42},{-78,20},{-120,20}}, color={0,0,127}));
end AHUGuideline36;
