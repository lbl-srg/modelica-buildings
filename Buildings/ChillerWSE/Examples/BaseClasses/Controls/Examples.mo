within Buildings.ChillerWSE.Examples.BaseClasses.Controls;
package Examples
  "Collection of models that illustrate model use and test models"
  extends Modelica.Icons.ExamplesPackage;

  model ChillerStageControl
    "Test the model ChillerWSE.Examples.BaseClasses.ChillerStageControl"
    extends Modelica.Icons.Example;

    Buildings.ChillerWSE.Examples.BaseClasses.Controls.ChillerStageControl chiStaCon(
      tWai=30)
      "Staging controller for chillers"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Modelica.Blocks.Sources.Pulse QTot(
      amplitude=0.4*chiStaCon.QEva_nominal,
      period=180,
      offset=0.5*chiStaCon.QEva_nominal)
      "Total cooling load in chillers"
      annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
    Modelica.Blocks.Sources.CombiTimeTable cooMod(table=[0,0; 360,0; 360,1; 720,1;
          720,2])
      "Cooling mode"
      annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  equation
    connect(QTot.y, chiStaCon.QTot)
      annotation (Line(points={{-39,-30},{-26,-30},
            {-26,4},{-12,4}}, color={0,0,127}));
    connect(cooMod.y[1], chiStaCon.cooMod)
      annotation (Line(points={{-39,50},{-26,
            50},{-26,8},{-12,8}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      __Dymola_Commands(file=
            "Resources/Scripts/Dymola/ChillerWSE/Examples/BaseClasses/Controls/Examples/ChillerStageControl.mos"
          "Simulate and Plot"));
  end ChillerStageControl;

  model ConstantSpeedPumpStageControl
    "Test the model ChillerWSE.Examples.BaseClasses.ConstatnSpeedPumpStageControl"
    extends Modelica.Icons.Example;

    Buildings.ChillerWSE.Examples.BaseClasses.Controls.ConstantSpeedPumpStageControl
    conSpePumSta(tWai=30)
      "Staging controller for constant speed pumps"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Modelica.Blocks.Sources.CombiTimeTable cooMod(table=[0,0; 360,0; 360,1; 720,1;
          720,2]) "Cooling mode"
      annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
    Modelica.Blocks.Sources.CombiTimeTable chiNumOn(table=[0,0; 360,0; 360,1; 540,
          1; 540,2; 720,2; 720,1; 900,1; 900,2]) "The number of running chillers"
      annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  equation
    connect(cooMod.y[1], conSpePumSta.cooMod)
      annotation (Line(points={{-39,50},{
            -26,50},{-26,8},{-12,8}}, color={0,0,127}));
    connect(chiNumOn.y[1], conSpePumSta.chiNumOn)
      annotation (Line(points={{-39,
            -30},{-26,-30},{-26,4},{-12,4}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      __Dymola_Commands(file=
            "Resources/Scripts/Dymola/ChillerWSE/Examples/BaseClasses/Controls/Examples/ConstantSpeedPumpStageControl.mos"
          "Simulate and Plot"));
  end ConstantSpeedPumpStageControl;

  model CoolingModeControl
    "Test the model ChillerWSE.Examples.BaseClasses.CoolingModeController"
    extends Modelica.Icons.Example;

    Buildings.ChillerWSE.Examples.BaseClasses.Controls.CoolingModeControl
      cooModCon(
      deaBan1=1,
      deaBan2=1,
      tWai=30)
      "Cooling mode controller used in integrared waterside economizer chilled water system"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Modelica.Blocks.Sources.Pulse wseCHWST(
      period=300,
      amplitude=15,
      offset=273.15 + 5) "WSE chilled water supply temperature"
      annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
    Modelica.Blocks.Sources.Constant TWetBub(k=273.15 + 5) "Wet bulb temperature"
      annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
    Modelica.Blocks.Sources.Constant TTowApp(k=5) "Cooling tower approach"
      annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
    Modelica.Blocks.Sources.Constant wseCHWRT(k=273.15 + 12)
      "Chilled water return temperature in waterside economizer"
      annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
    Modelica.Blocks.Sources.Constant CHWSTSet(k=273.15 + 10)
      "Chilled water supply temperature setpoint"
      annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  equation
    connect(CHWSTSet.y, cooModCon.CHWSTSet)
      annotation (Line(points={{-39,90},{-26,
            90},{-26,8},{-12,8}}, color={0,0,127}));
    connect(TWetBub.y, cooModCon.TWetBul)
      annotation (Line(points={{-39,50},{-26,50},
            {-26,4},{-12,4}}, color={0,0,127}));
    connect(TTowApp.y, cooModCon.towTApp)
      annotation (Line(points={{-39,10},{-26,10},
            {-26,0},{-12,0}}, color={0,0,127}));
    connect(wseCHWST.y, cooModCon.wseCHWST)
      annotation (Line(points={{-39,-30},{-26,
            -30},{-26,-4},{-12,-4}}, color={0,0,127}));
    connect(wseCHWRT.y, cooModCon.wseCHWRT)
      annotation (Line(points={{-39,-70},{-26,
            -70},{-26,-8},{-12,-8}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      __Dymola_Commands(file=
            "Resources/Scripts/Dymola/ChillerWSE/Examples/BaseClasses/Controls/Examples/CoolingModeControl.mos"
          "Simulate and Plot"));
  end CoolingModeControl;

  model CoolingTowerSpeedControl
    "Test the model ChillerWSE.Examples.BaseClasses.CoolingTowerSpeedControl"
    extends Modelica.Icons.Example;

    Buildings.ChillerWSE.Examples.BaseClasses.Controls.CoolingTowerSpeedControl
      cooTowSpeCon(controllerType=Modelica.Blocks.Types.SimpleController.PI,
        reset=Buildings.Types.Reset.Disabled)
      "Cooling tower speed controller"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Modelica.Blocks.Sources.Sine CHWST(
      amplitude=2,
      freqHz=1/360,
      offset=273.15 + 5)
      "Chilled water supply temperature"
      annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
    Modelica.Blocks.Sources.Constant CWSTSet(k=273.15 + 20)
      "Condenser water supply temperature setpoint"
      annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
    Modelica.Blocks.Sources.Sine CWST(
      amplitude=5,
      freqHz=1/360,
      offset=273.15 + 20)
      "Condenser water supply temperature"
      annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
    Modelica.Blocks.Sources.Constant CHWSTSet(k=273.15 + 6)
      "Chilled water supply temperature setpoint"
      annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
    Modelica.Blocks.Sources.CombiTimeTable cooMod(table=[0,0; 360,0; 360,1; 720,1;
          720,2])
      "Cooling mode"
      annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  equation
    connect(CWSTSet.y, cooTowSpeCon.CWST_set)
      annotation (Line(points={{-39,90},{
            -22,90},{-22,88},{-22,22},{-22,10},{-12,10}}, color={0,0,127}));
    connect(cooMod.y[1], cooTowSpeCon.cooMod)
      annotation (Line(points={{-39,50},{-26,50},{-26,5.55556},{-12,5.55556}},
        color={0,0,127}));
    connect(CHWSTSet.y, cooTowSpeCon.CHWST_set)
      annotation (Line(points={{-39,10},{-32,10},{-32,1.11111},{-12,1.11111}},
        color={0,0,127}));
    connect(CWST.y, cooTowSpeCon.CWST)
      annotation (Line(points={{-39,-30},{-32, -30},{-32,-3.33333},{-12,-3.33333}},
        color={0,0,127}));
    connect(CHWST.y, cooTowSpeCon.CHWST)
      annotation (Line(points={{-39,-70},{-32,-70},{-24,-70},
        {-24,-7.77778},{-12,-7.77778}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      __Dymola_Commands(file=
            "Resources/Scripts/Dymola/ChillerWSE/Examples/BaseClasses/Controls/Examples/CoolingTowerSpeedControl.mos"
          "Simulate and Plot"));
  end CoolingTowerSpeedControl;

  model VariableSpeedPumpStageControl
    "Test the model ChillerWSE.Examples.BaseClasses.VariableSpeedPumpStageControl"
    extends Modelica.Icons.Example;
    parameter Modelica.SIunits.MassFlowRate m_flow_nominal=100 "Nominal mass flowrate";

    Buildings.ChillerWSE.Examples.BaseClasses.Controls.VariableSpeedPumpStageControl
      varSpePumSta(tWai=30, m_flow_nominal=m_flow_nominal)
      "Staging controller for variable speed pumps"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Modelica.Blocks.Sources.Pulse speSig(
      amplitude=0.8,
      period=180,
      offset=0.2) "Speed signal"
      annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
    Modelica.Blocks.Sources.Sine masFlo(
      offset=0.5*m_flow_nominal,
      freqHz=1/360,
      amplitude=0.5*m_flow_nominal)
      "Mass flowrate"
      annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  equation
    connect(speSig.y, varSpePumSta.speSig)
      annotation (Line(points={{-39,-20},{-32,
            -20},{-32,4},{-12,4}}, color={0,0,127}));
    connect(masFlo.y, varSpePumSta.masFloPum)
      annotation (Line(points={{-39,40},{-30,
            40},{-30,8},{-12,8}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      __Dymola_Commands(file=
            "Resources/Scripts/Dymola/ChillerWSE/Examples/BaseClasses/Controls/Examples/VariableSpeedPumpStageControl.mos"
          "Simulate and Plot"));
  end VariableSpeedPumpStageControl;
  annotation (Documentation(info="<html>
<p>

</p>
</html>"));
end Examples;
