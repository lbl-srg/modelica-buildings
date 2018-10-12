within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer;
block Tuning
  "Defines a value used to tune the economizer outlet temperature prediction"

  parameter Modelica.SIunits.Time ecoOnTimDec = 60*60
  "Economizer enable time needed to allow decrease of the tuning parameter";

  parameter Modelica.SIunits.Time ecoOnTimInc = 30*60
  "Economizer enable time needed to allow increase of the tuning parameter";


  CDL.Interfaces.BooleanInput uEcoSta
    "Water side economizer enable disable status"
    annotation (Placement(transformation(extent={{-220,100},{-180,140}})));
  CDL.Logical.Timer tim
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  CDL.Logical.Change cha
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  CDL.Logical.And and2
    annotation (Placement(transformation(extent={{0,100},{20,120}})));

  CDL.Continuous.GreaterEqual greEqu
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));
  CDL.Continuous.Sources.Constant ecoOnTim(k=ecoOnTimDec)
    "Check if econ was on for the defined time period"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  CDL.Continuous.GreaterEqual greEqu1
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  CDL.Continuous.Sources.Constant ecoOnTim1(k=ecoOnTimInc)
    "Check if econ was on for the defined time period"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
equation
  connect(uEcoSta, tim.u)
    annotation (Line(points={{-200,120},{-122,120}}, color={255,0,255}));
  connect(uEcoSta, cha.u) annotation (Line(points={{-200,120},{-140,120},{-140,
          70},{-122,70}},
                      color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,-180},
            {180,180}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-180,-180},{180,180}})));
end Tuning;
