within IceStorage.BaseClasses;
model ModeControl "Storage mode controller"
  parameter Modelica.SIunits.HeatFlowRate smaLoa = 1e-03;
  parameter Modelica.SIunits.Temperature TFre = 273.15
    "Freezing temperature of water or the latent energy storage material";
  parameter Modelica.SIunits.Time waiTim=120
    "Wait time before transition fires";
  parameter Real fraCha_min = 0.05 "Minimum allowable fraction of charge in the tank";
  parameter Real fraCha_max = 1 "Maximum allowable fraction of charge in the tank";
  parameter Modelica.SIunits.TemperatureDifference dTif_min = 0.2
    "Temperature difference tolerance between inlet temperature and freezing temperature";

  Modelica.Blocks.Interfaces.IntegerOutput y "Actual operation mode"              annotation (Placement(
        transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={
            {100,-10},{120,10}})));
  Modelica.StateGraph.StepWithSignal cha(nIn=2, nOut=2) "Charing mode"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-10,0})));
  Modelica.StateGraph.InitialStepWithSignal dor(nIn=2, nOut=2) "Dormant mode"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-10,50})));
  Modelica.StateGraph.StepWithSignal disCha(nIn=2, nOut=2) "Discharging mode"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-10,-60})));
  Modelica.StateGraph.Transition dorToCha(
    condition=u == Integer(IceStorage.Types.IceThermalStorageMode.Charging)
         and TIn <= TFre - dTif_min and locLoa <= -smaLoa and fraCha < 0.999,
    enableTimer=true,
    waitTime=waiTim) "Dormant to charging mode" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,20})));
  Modelica.StateGraph.Transition chaToDis(
    condition=u == Integer(IceStorage.Types.IceThermalStorageMode.Discharging)
         and TIn >= TFre + dTif_min and locLoa >= smaLoa,
    enableTimer=true,
    waitTime=waiTim)
    "Charging mode to discharging mode"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,-34})));
  Modelica.StateGraph.Transition chaToDor(
    condition=TIn >= TFre - dTif_min and locLoa >= -smaLoa or fraCha >= 0.999,
    enableTimer=true,
    waitTime=waiTim) "Charging mode to dormant mode" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,20})));
  Modelica.StateGraph.Transition disToCha(
    condition=u == Integer(IceStorage.Types.IceThermalStorageMode.Charging)
         and TIn <= TFre - dTif_min and locLoa <= -smaLoa,
    enableTimer=true,
    waitTime=waiTim)
    "Discharging mode to charging mode"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-30})));
  Modelica.StateGraph.Transition disToDor(
    condition=TIn <= TFre + dTif_min or locLoa <= smaLoa or fraCha <= 0.001,
    enableTimer=true,
    waitTime=waiTim) "Discharging mode to dormant mode" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,-60})));
  Modelica.StateGraph.Transition dorToDis(
    condition=u == Integer(IceStorage.Types.IceThermalStorageMode.Discharging)
         and TIn >= TFre + dTif_min and locLoa >= smaLoa and fraCha > 0.001,
    enableTimer=true,
    waitTime=waiTim) "Dormant to discharging mode" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-70,0})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToIntCha(
    final integerTrue=Integer(IceStorage.Types.IceThermalStorageMode.Charging),
    final integerFalse=0)
    annotation (Placement(transformation(extent={{48,-10},{68,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToIntDis(
    final integerFalse=0,
    final integerTrue=Integer(IceStorage.Types.IceThermalStorageMode.Discharging))
    annotation (Placement(transformation(extent={{50,-50},{70,-30}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt(
    nin=3)
    annotation (Placement(transformation(extent={{76,-10},{96,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToIntDor(
    final integerTrue=Integer(IceStorage.Types.IceThermalStorageMode.Dormant),
    final integerFalse=0)
    annotation (Placement(transformation(extent={{48,30},{68,50}})));
  Modelica.Blocks.Interfaces.RealInput locLoa(unit="W") "Local load"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput TIn(unit="K", displayUnit="degC")
    "Inlet temperature" annotation (Placement(transformation(extent={{-140,-20},
            {-100,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.IntegerInput u "Desired operation mode"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  Modelica.Blocks.Interfaces.RealInput fraCha(unit="1") "Fraction of charge"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
equation
  connect(dor.outPort[1], dorToCha.inPort) annotation (Line(points={{-10.25,39.5},
          {-10.25,34},{-40,34},{-40,24}}, color={0,0,0}));
  connect(dor.outPort[2], dorToDis.inPort) annotation (Line(points={{-9.75,39.5},
          {-9.75,34},{-70,34},{-70,4}}, color={0,0,0}));
  connect(dorToCha.outPort, cha.inPort[1]) annotation (Line(points={{-40,18.5},{
          -40,14},{-10.5,14},{-10.5,11}}, color={0,0,0}));
  connect(cha.outPort[1], chaToDis.inPort) annotation (Line(points={{-10.25,-10.5},
          {-10.25,-20},{-40,-20},{-40,-30}}, color={0,0,0}));
  connect(chaToDis.outPort, disCha.inPort[1]) annotation (Line(points={{-40,-35.5},
          {-40,-46},{-10.5,-46},{-10.5,-49}}, color={0,0,0}));
  connect(disCha.outPort[1], disToCha.inPort) annotation (Line(points={{-10.25,-70.5},
          {-10.25,-82},{20,-82},{20,-34}}, color={0,0,0}));
  connect(disToCha.outPort, cha.inPort[2]) annotation (Line(points={{20,-28.5},{
          20,14},{-9.5,14},{-9.5,11}}, color={0,0,0}));
  connect(cha.outPort[2], chaToDor.inPort) annotation (Line(points={{-9.75,-10.5},
          {-9.75,-18},{30,-18},{30,16}}, color={0,0,0}));
  connect(chaToDor.outPort, dor.inPort[1]) annotation (Line(points={{30,21.5},{30,
          66},{-10.5,66},{-10.5,61}}, color={0,0,0}));
  connect(disCha.outPort[2], disToDor.inPort) annotation (Line(points={{-9.75,-70.5},
          {-9.75,-82},{40,-82},{40,-64}}, color={0,0,0}));
  connect(disToDor.outPort, dor.inPort[2]) annotation (Line(points={{40,-58.5},{
          40,70},{-9.5,70},{-9.5,61}}, color={0,0,0}));
  connect(dorToDis.outPort, disCha.inPort[2]) annotation (Line(points={{-70,-1.5},
          {-70,-44},{-9.5,-44},{-9.5,-49}}, color={0,0,0}));
  connect(booToIntDor.y, mulSumInt.u[1]) annotation (Line(points={{70,40},{72,40},
          {72,4.66667},{74,4.66667}}, color={255,127,0}));
  connect(booToIntCha.y, mulSumInt.u[2])
    annotation (Line(points={{70,0},{72,0},{72,0},{74,0}}, color={255,127,0}));
  connect(booToIntDis.y, mulSumInt.u[3]) annotation (Line(points={{72,-40},{72,-4.66667},
          {74,-4.66667}}, color={255,127,0}));
  connect(mulSumInt.y, y)
    annotation (Line(points={{98,0},{110,0}}, color={255,127,0}));
  connect(dor.active, booToIntDor.u) annotation (Line(points={{1,50},{26,50},{26,
          40},{46,40}}, color={255,0,255}));
  connect(cha.active, booToIntCha.u)
    annotation (Line(points={{1,0},{46,0}}, color={255,0,255}));
  connect(disCha.active, booToIntDis.u) annotation (Line(points={{1,-60},{18,-60},
          {18,-40},{48,-40}}, color={255,0,255}));
  annotation (defaultComponentName="stoCon",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid), Text(
        extent={{-148,150},{152,110}},
        textString="%name",
        lineColor={0,0,255})}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end ModeControl;
