within Buildings.Templates.Components;
package HeatExchangers
  extends Modelica.Icons.Package;

  model DXMultiStage "Multi-stage"
    extends Buildings.Templates.Components.HeatExchangers.Interfaces.PartialHeatExchangerDX(
      final typ=Buildings.Templates.Components.Types.HeatExchanger.DXMultiStage);

    Fluid.HeatExchangers.DXCoils.AirCooled.MultiStage coi(
      redeclare final package Medium = Medium,
      final datCoi=datCoi,
      final dp_nominal=dp_nominal,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
      "DX coil"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Modelica.Blocks.Routing.RealPassThrough TWet if not have_dryCon
      annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
    Modelica.Blocks.Routing.RealPassThrough TDry if have_dryCon
      annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

  equation
    /* Hardware point connection - start */
    connect(bus.y, coi.stage);
    /* Hardware point connection - end */
    connect(port_a, coi.port_a)
      annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
    connect(coi.port_b, port_b)
      annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
    connect(busWea.TWetBul, TWet.u) annotation (Line(
        points={{-60,100},{-60,40},{-80,40},{-80,20},{-62,20}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(busWea.TDryBul, TDry.u) annotation (Line(
        points={{-60,100},{-60,40},{-80,40},{-80,-20},{-62,-20}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(TWet.y, coi.TConIn) annotation (Line(points={{-39,20},{-30,20},{-30,3},
            {-11,3}}, color={0,0,127}));
    connect(TDry.y, coi.TConIn) annotation (Line(points={{-39,-20},{-30,-20},{-30,
            3},{-11,3}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end DXMultiStage;

  model DXVariableSpeed "Modulating"
    extends Buildings.Templates.Components.HeatExchangers.Interfaces.PartialHeatExchangerDX(
      final typ=Buildings.Templates.Components.Types.HeatExchanger.DXVariableSpeed);

    parameter Real minSpeRat(min=0,max=1)=0.1 "Minimum speed ratio";
    parameter Real speRatDeaBan=0.05 "Deadband for minimum speed ratio";

    Fluid.HeatExchangers.DXCoils.AirCooled.VariableSpeed coi(
      redeclare final package Medium = Medium,
      final datCoi=datCoi,
      final minSpeRat=minSpeRat,
      final speRatDeaBan=speRatDeaBan,
      final dp_nominal=dp_nominal,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
      "DX coil"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

    Modelica.Blocks.Routing.RealPassThrough TWet if not have_dryCon
      annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
    Modelica.Blocks.Routing.RealPassThrough TDry if have_dryCon
      annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  equation
    /* Hardware point connection - start */
    connect(bus.y, coi.speRat);
    /* Hardware point connection - end */
    connect(port_a, coi.port_a)
      annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
    connect(coi.port_b, port_b)
      annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
    connect(busWea.TWetBul, TWet.u) annotation (Line(
        points={{-60,100},{-60,40},{-80,40},{-80,20},{-62,20}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(busWea.TDryBul, TDry.u) annotation (Line(
        points={{-60,100},{-60,40},{-80,40},{-80,-20},{-62,-20}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(TWet.y, coi.TConIn) annotation (Line(points={{-39,20},{-30,20},{-30,3},
            {-11,3}}, color={0,0,127}));
    connect(TDry.y, coi.TConIn) annotation (Line(points={{-39,-20},{-30,-20},{-30,
            3},{-11,3}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end DXVariableSpeed;

  model WetCoilCounterFlow "Discretized wet heat exchanger model"
    extends Buildings.Templates.Components.HeatExchangers.Interfaces.PartialHeatExchangerWater(
      final typ=Buildings.Templates.Components.Types.HeatExchanger.WetCoilCounterFlow);

    parameter Modelica.SIunits.ThermalConductance UA_nominal=
      dat.getReal(varName=id + ".Mechanical." + funStr + " coil.UA (dry coil conditions).value")
      "Thermal conductance at nominal flow"
      annotation(Evaluate=true);
    parameter Real r_nominal=2/3
      "Ratio between air-side and water-side convective heat transfer coefficient";
    parameter Integer nEle=4
      "Number of pipe segments used for discretization";

    Fluid.HeatExchangers.WetCoilCounterFlow hex(
      redeclare final package Medium1 = Medium1,
      redeclare final package Medium2 = Medium2,
      final m1_flow_nominal=m1_flow_nominal,
      final m2_flow_nominal=m2_flow_nominal,
      final dp1_nominal=dp1_nominal,
      final dp2_nominal=dp2_nominal,
      final UA_nominal=UA_nominal,
      final r_nominal=r_nominal,
      final nEle=nEle,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
      "Coil"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  equation
    connect(port_b2, hex.port_b2) annotation (Line(points={{-100,-60},{-20,-60},{-20,
            -6},{-10,-6}}, color={0,127,255}));
    connect(hex.port_a1, port_a1) annotation (Line(points={{-10,6},{-20,6},{-20,60},
            {-100,60}}, color={0,127,255}));
    connect(hex.port_b1, port_b1) annotation (Line(points={{10,6},{20,6},{20,60},{
            100,60}}, color={0,127,255}));
    connect(hex.port_a2, port_a2) annotation (Line(points={{10,-6},{20,-6},{20,-60},
            {100,-60}}, color={0,127,255}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end WetCoilCounterFlow;

  model WetCoilEffectivenessNTU "Effectiveness-NTU wet heat exchanger model"
    extends Buildings.Templates.Components.HeatExchangers.Interfaces.PartialHeatExchangerWater(
      final typ=Buildings.Templates.Components.Types.HeatExchanger.WetCoilEffectivenessNTU);

    parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(max=0)=
      -1 * dat.getReal(varName=id + ".Mechanical." + funStr + " coil.Capacity.value")
      "Nominal heat flow rate"
      annotation (Dialog(
        group="Nominal condition"));
    parameter Modelica.SIunits.Temperature T_a1_nominal=
      dat.getReal(varName=id + ".Mechanical." + funStr + " coil.Entering liquid temperature.value")
      "Nominal entering liquid temperature"
      annotation (Dialog(
        group="Nominal condition"));
    parameter Modelica.SIunits.Temperature T_a2_nominal=
      dat.getReal(varName=id + ".Mechanical." + funStr + " coil.Entering air temperature.value")
      "Nominal entering air temperature"
      annotation (Dialog(
        group="Nominal condition"));
    parameter Modelica.SIunits.MassFraction w_a2_nominal=
      dat.getReal(varName=id + ".Mechanical." + funStr + " coil.Entering air humidity ratio.value")
      "Nominal entering air humidity ratio"
      annotation (Dialog(
        group="Nominal condition"));
    parameter Buildings.Fluid.Types.HeatExchangerConfiguration configuration=
      Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow
      "Heat exchanger configuration"
      annotation (Evaluate=true);

    Fluid.HeatExchangers.WetCoilEffectivenessNTU hex(
      redeclare final package Medium1 = Medium1,
      redeclare final package Medium2 = Medium2,
      final m1_flow_nominal=m1_flow_nominal,
      final m2_flow_nominal=m2_flow_nominal,
      final dp1_nominal=dp1_nominal,
      final dp2_nominal=dp2_nominal,
      final use_Q_flow_nominal=true,
      final configuration=configuration,
      final Q_flow_nominal=Q_flow_nominal,
      final T_a1_nominal=T_a1_nominal,
      final T_a2_nominal=T_a2_nominal,
      final w_a2_nominal=w_a2_nominal)
      "Coil"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  equation
    connect(port_b2, hex.port_b2) annotation (Line(points={{-100,-60},{-20,-60},{-20,
            -6},{-10,-6}}, color={0,127,255}));
    connect(hex.port_a1, port_a1) annotation (Line(points={{-10,6},{-20,6},{-20,60},
            {-100,60}}, color={0,127,255}));
    connect(hex.port_b1, port_b1) annotation (Line(points={{10,6},{20,6},{20,60},{
            100,60}}, color={0,127,255}));
    connect(hex.port_a2, port_a2) annotation (Line(points={{10,-6},{20,-6},{20,-60},
            {100,-60}}, color={0,127,255}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end WetCoilEffectivenessNTU;

  model DryCoilEffectivenessNTU "Effectiveness-NTU dry heat exchanger model"
    extends Buildings.Templates.Components.HeatExchangers.Interfaces.PartialHeatExchangerWater(
      final typ=Buildings.Templates.Components.Types.HeatExchanger.DryCoilEffectivenessNTU);

    parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(min=0)=
      dat.getReal(varName=id + ".Mechanical." + funStr + " coil.Capacity.value")
      "Nominal heat flow rate"
      annotation(Dialog(group = "Nominal condition"));
    parameter Modelica.SIunits.Temperature T_a1_nominal=
      dat.getReal(varName=id + ".Mechanical." + funStr + " coil.Entering liquid temperature.value")
      "Nominal inlet temperature"
      annotation(Dialog(group = "Nominal condition"));
    parameter Modelica.SIunits.Temperature T_a2_nominal=
      dat.getReal(varName=id + ".Mechanical." + funStr + " coil.Entering air temperature.value")
      "Nominal inlet temperature"
      annotation(Dialog(group = "Nominal condition"));
    parameter Buildings.Fluid.Types.HeatExchangerConfiguration configuration=
      Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow
      "Heat exchanger configuration"
      annotation (Evaluate=true);

    Fluid.HeatExchangers.DryCoilEffectivenessNTU hex(
      redeclare final package Medium1 = Medium1,
      redeclare final package Medium2 = Medium2,
      final m1_flow_nominal=m1_flow_nominal,
      final m2_flow_nominal=m2_flow_nominal,
      final dp1_nominal=dp1_nominal,
      final dp2_nominal=dp2_nominal,
      final use_Q_flow_nominal=true,
      final configuration=configuration,
      final Q_flow_nominal=Q_flow_nominal,
      final T_a1_nominal=T_a1_nominal,
      final T_a2_nominal=T_a2_nominal)
      "Coil"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  equation
    connect(port_b2, hex.port_b2) annotation (Line(points={{-100,-60},{-20,-60},{-20,
            -6},{-10,-6}}, color={0,127,255}));
    connect(hex.port_a1, port_a1) annotation (Line(points={{-10,6},{-20,6},{-20,60},
            {-100,60}}, color={0,127,255}));
    connect(hex.port_b1, port_b1) annotation (Line(points={{10,6},{20,6},{20,60},{
            100,60}}, color={0,127,255}));
    connect(hex.port_a2, port_a2) annotation (Line(points={{10,-6},{20,-6},{20,-60},
            {100,-60}}, color={0,127,255}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end DryCoilEffectivenessNTU;

  package Interfaces "Classes defining the component interfaces"
    extends Modelica.Icons.InterfacesPackage;

    partial model PartialHeatExchangerDX
      // Air medium needed for type compatibility with DX coil models.
      extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;

      parameter Buildings.Templates.Components.Types.HeatExchanger typ
        "Type of heat exchanger"
        annotation (Evaluate=true, Dialog(group="Configuration"));
      // DX coils get nominal air flow rate from data record.
      // Only the air pressure drop needs to be declared.
      parameter Modelica.SIunits.PressureDifference dp_nominal
        "Air pressure drop"
        annotation (Dialog(group="Nominal condition"));

      replaceable parameter
        Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil datCoi
        constrainedby Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil
        "Performance record"
        annotation(choicesAllMatching=true);

      outer parameter Boolean have_dryCon
        "Set to true for purely sensible cooling of the condenser";
      outer parameter String funStr
        "String used to identify the coil function";
      outer parameter String id
        "System identifier";
      outer parameter Templates.BaseClasses.ExternDataLocal.JSONFile dat
        "External parameter file";

      BoundaryConditions.WeatherData.Bus busWea
        "Weather bus"
        annotation (Placement(
            transformation(extent={{-80,80},{-40,120}}),
            iconTransformation(extent={{-70,90},
                {-50,110}})));
      Buildings.Templates.Components.Interfaces.Bus bus
        "Control bus"
        annotation (Placement(transformation(
            extent={{-20,-20},{20,20}},
            rotation=0,
            origin={0,100}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={0,100})));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false),
        graphics={Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,255},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid)}), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end PartialHeatExchangerDX;

    partial model PartialHeatExchangerWater
      extends Buildings.Fluid.Interfaces.PartialFourPortInterface;

      parameter Buildings.Templates.Components.Types.HeatExchanger typ
        "Type of heat exchanger"
        annotation (Evaluate=true, Dialog(group="Configuration"));
      parameter Modelica.SIunits.PressureDifference dp1_nominal
        "Liquid pressure drop"
        annotation (Dialog(group="Nominal condition"));
      parameter Modelica.SIunits.PressureDifference dp2_nominal
        "Air pressure drop"
        annotation (Dialog(group="Nominal condition"));

      outer parameter String funStr
        "String used to identify the coil function";
      outer parameter String id
        "System identifier";
      outer parameter Templates.BaseClasses.ExternDataLocal.JSONFile dat
        "External parameter file";

      annotation (Icon(coordinateSystem(preserveAspectRatio=false),
        graphics={Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,255},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid)}), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end PartialHeatExchangerWater;
  end Interfaces;
end HeatExchangers;
