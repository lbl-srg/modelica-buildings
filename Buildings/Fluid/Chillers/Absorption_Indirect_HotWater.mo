within Buildings.Fluid.Chillers;
model Absorption_Indirect_HotWater
  "Absorption indirect chiller with performance curves model"
    extends Buildings.Fluid.Interfaces.SixPortHeatMassExchanger(
     dp1_nominal=200,
     dp2_nominal=200,
     dp3_nominal=300,
     massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
     energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
     show_T=true,
     T1_start = 273.15+25,
     T2_start = 273.15+5,
     T3_start= 273.15 + 80,
     m1_flow_nominal= mCon_flow_nominal,
     m2_flow_nominal= mEva_flow_nominal,
     m3_flow_nominal= mGen_flow_nominal,
   redeclare final Buildings.Fluid.MixingVolumes.MixingVolume
      vol1(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
           massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
            V=m1_flow_nominal*tau1/rho1_nominal,
            nPorts=2,final prescribedHeatFlowRate=true),
      vol2(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
           massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
            V=m2_flow_nominal*tau2/rho2_nominal,
            nPorts=2,final prescribedHeatFlowRate=true),
      vol3(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
           massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
           V=m3_flow_nominal*tau3/rho3_nominal,
           nPorts=2,final prescribedHeatFlowRate=true));

  parameter Buildings.Fluid.Chillers.Data.AbsorptionIndirect.Generic  per
   "Performance data"
    annotation (choicesAllMatching= true,
       Placement(transformation(extent={{48,66},{68,86}})));
  final parameter Modelica.SIunits.HeatFlowRate
     QEva_heatflow_nominal= per.QEva_flow_nominal
    "Nominal heat flow at the evaporator"
      annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal= per.mCon_flow_nominal
   "Nominal mass flow at Condenser"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal= per.mEva_flow_nominal
   "Nominal mass flow at Evaorator"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.HeatFlowRate Q_flow_small = -QEva_heatflow_nominal*1E-9
    "Small value for heat flow rate or power, used to avoid division by zero";

  /*
  hot water flow rate
  parameter Modelica.SIunits.SpecificHeatCapacity cpWat=
    Medium1.specificHeatCapacityCp(Medium.setState_pTX(
      p = Medium1.p,
      T = Medium1.T,
      X = Medium1.X));
  */



  BaseClasses.AbsorptionIndirect absBlo(per=per)
   "Absorption indirect chiller equations block"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Interfaces.BooleanInput on
   "Chiller turn On/off inout signal "
    annotation (Placement(transformation(extent=
           {{-168,-14},{-140,14}}), iconTransformation(extent={{-122,-10},{-100,12}})));
  Modelica.Blocks.Interfaces.RealInput TEvaSet(final unit="K", displayUnit="degC")
   "Evaporator setpoint leaving water temperature"
    annotation (Placement(
        transformation(extent={{-166,-92},{-140,-66}}), iconTransformation(
          extent={{-122,-100},{-100,-78}})));
  Modelica.Blocks.Sources.RealExpression QEvaFloSet(final y=
        Buildings.Utilities.Math.Functions.smoothMin(
            x1 = mEvaFlo.y*(hEvaSet.y - inStream(port_a2.h_outflow)),
            x2 = -Q_flow_small,
        deltaX = Q_flow_small/100))
   "Setpoint heat flow rate of the evaporator"
    annotation (Placement(transformation(extent={{-138,-30},{-118,-10}})));
  Modelica.Blocks.Sources.RealExpression hEvaSet(final y=
        Medium2.specificEnthalpy_pTX(
        p = port_b2.p,
        T = TEvaSet,
        X = cat(1,
              port_b2.Xi_outflow,{1 - sum(port_b2.Xi_outflow)})))
   "Chilled water setpoint enthalpy"
    annotation (Placement(transformation(extent={{-138,-64},{-118,-44}})));
  Modelica.Blocks.Sources.RealExpression mEvaFlo(y=vol2.ports[1].m_flow)
   "Evaporator water mass flow rate"
    annotation (Placement(transformation(extent={{-138,-80},{-118,-60}})));
  Modelica.Blocks.Interfaces.RealOutput P
   "Chiller pump power"
    annotation (Placement(transformation(extent={{100,20},{120,40}}),
                            iconTransformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Interfaces.RealOutput QGen
   "Generator heat flow "
    annotation (
      Placement(transformation(extent={{100,-24},{120,-4}}), iconTransformation(extent={{
            100,10},{120,30}})));
  Modelica.Blocks.Interfaces.RealOutput QEva
   "Evaporator heat flow "
    annotation (
      Placement(transformation(extent={{100,-42},{120,-22}}), iconTransformation(extent={
            {100,-96},{120,-76}})));
  Modelica.Blocks.Interfaces.RealOutput QCon
   "Condenser heat flow "
    annotation (
      Placement(transformation(extent={{100,48},{120,68}}), iconTransformation(extent={{100,
            74},{120,94}})));
  Modelica.Blocks.Sources.RealExpression TConEnt(y=Medium1.temperature(
        Medium1.setState_phX(port_a1.p, inStream(port_a1.h_outflow))))
   "Condenser entering water temperature"
    annotation (Placement(transformation(extent={{-138,24},{-118,44}})));
  Modelica.Blocks.Sources.RealExpression TEvaLvg(y=vol2.heatPort.T)
   "Evaporator leaving water temperature"
    annotation (Placement(transformation(extent={{-138,-48},{-118,-28}})));
  Modelica.Blocks.Interfaces.RealInput TGenEnt(final unit="K", displayUnit="degC")
   "Generator entering steam temperature"
    annotation (Placement(
        transformation(extent={{-166,48},{-140,74}}), iconTransformation(extent=
           {{-124,68},{-102,90}})));
  Modelica.Blocks.Sources.RealExpression TConLvg(y=vol1.heatPort.T)
    "Condenser leaving water temperature"
    annotation (Placement(transformation(extent={{-138,40},{-118,60}})));
protected
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFloCon
    "Prescribed heat flow rate for the condenser"
    annotation (Placement(transformation(extent={{-57,42},{-37,62}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFloEva
    "Prescribed heat flow rate for the Evaporator"
    annotation (Placement(transformation(extent={{-55,-52},{-35,-32}})));
equation
  connect(on,absBlo. on)
    annotation (Line(points={{-154,0},{-122,0},{-122,30},{-101,30}},
                               color={255,0,255}));
  connect(absBlo.QCon, preHeaFloCon.Q_flow)
    annotation (Line(points={{-79,38},{-68,38},{-68,52},{-57,52}},
                               color={0,0,127}));
  connect(preHeaFloCon.port, vol1.heatPort)
    annotation (Line(points={{-37,52},{-20,52},{-20,70},{-10,70}},
                               color={191,0,0}));
  connect(absBlo.QCon, QCon)
    annotation (Line(points={{-79,38},{90,38},{90,58},{110,58}},
                                color={0,0,127}));
  connect(absBlo.QEva, preHeaFloEva.Q_flow)
    annotation (Line(points={{-79,24.2},{-68,24.2},{-68,-42},{-55,-42}},
                                 color={0,0,127}));
  connect(preHeaFloEva.port, vol2.heatPort)
    annotation (Line(points={{-35,-42},{-16,-42},{-16,10},{-10,10}},
                                  color={191,0,0}));
  connect(absBlo.P, P)
    annotation (Line(points={{-79,33.8},{88,33.8},{88,30},{110,30}},
                                  color={0,0,127}));
  connect(absBlo.QGen, QGen)
    annotation (Line(points={{-79,30},{80,30},{80,-14},{110,-14}},
                                   color={0,0,127}));
  connect(TGenEnt,absBlo. TGenEnt)
    annotation (Line(points={{-153,61},{-110,61},{-110,38.8},{-101,38.8}},
                                    color={0,0,127}));
  connect(TConEnt.y,absBlo. TConEnt)
    annotation (Line(points={{-117,34},{-110,34},{-110,33.4},{-101,33.4}},
                                    color={0,0,127}));
  connect(TEvaLvg.y,absBlo. TEvaLvg)
    annotation (Line(points={{-117,-38},{-110,-38},{-110,22.6},{-101,22.6}},
                                    color={0,0,127}));
  connect(QEvaFloSet.y,absBlo. QEvaFloSet)
    annotation (Line(points={{-117,-20},{-114,-20},{-114,26.6},{-101,26.6}},
                                    color={0,0,127}));
  connect(TConLvg.y, absBlo.TConLvg)
    annotation (Line(points={{-117,50},{-112,50},{-112,37.2},{-101,37.2}},
                                    color={0,0,127}));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-96,98},{98,-100}},
          lineColor={238,46,47},
          lineThickness=0.5,
          fillColor={154,154,154},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-72,0},{-38,28}},
          lineColor={238,46,47},
          lineThickness=0.5),
        Rectangle(
          extent={{-24,88},{30,62}},
          lineColor={28,108,200},
          fillColor={238,46,47},
          fillPattern=FillPattern.CrossDiag,
          pattern=LinePattern.Dash),
        Rectangle(
          extent={{-22,-46},{32,-84}},
          lineColor={170,213,255},
          fillColor={28,108,200},
          fillPattern=FillPattern.Forward,
          pattern=LinePattern.Dash),
        Rectangle(
          extent={{-22,26},{26,-14}},
          lineColor={244,125,35},
          fillColor={65,145,136},
          fillPattern=FillPattern.Forward,
          pattern=LinePattern.Dash),
        Line(
          points={{60,76},{60,-66}},
          color={28,108,200},
          thickness=0.5),
        Line(points={{-56,-66},{-56,62},{-56,76}}, color={238,46,47},
          thickness=0.5),
        Line(
          points={{54,18},{66,18},{54,4},{66,4},{54,18}},
          color={238,46,47},
          thickness=0.5),
        Polygon(
          points={{-56,26},{-42,8},{-66,8},{-70,8},{-56,26}},
          lineColor={0,0,255},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{30,76},{48,76},{60,76}}, color={0,0,255}),
        Line(points={{32,-66},{60,-66}}, color={0,0,255}),
        Line(points={{-22,-66},{-56,-66}}, color={238,46,47}),
        Line(points={{-24,76},{-56,76}}, color={238,46,47}),
        Line(points={{-40,76}}, color={238,46,47}),
        Line(
          points={{26,6},{40,6},{46,6},{46,-4},{80,-4}},
          color={238,46,47},
          thickness=0.5,
          pattern=LinePattern.DashDot),
        Line(
          points={{-22,6},{-34,6}},
          color={85,255,255},
          thickness=0.5,
          pattern=LinePattern.DashDot),
        Line(
          points={{-34,6},{-34,-2}},
          color={85,255,255},
          thickness=0.5),
        Line(
          points={{-34,-2},{-82,-2}},
          color={85,255,255},
          thickness=0.5,
          pattern=LinePattern.DashDot)}), Diagram(coordinateSystem(extent={{-140,-100},{100,
            100}})),
            defaultComponentName="absChi",
    Documentation(info="<html>
<p>
Model for an absorption indirect steam chiller using the performance curves method as described
in the EnergyPlus reference: Indirect Absorption Chiller.
</p>
<p>
The model uses six non-dimensional equations or curves stated in <a href=\"Buildings.Fluid.Chillers.BaseClasses.AbsorptionIndirect\">
Buildings.Fluid.Chillers.BaseClasses.AbsorptionIndirect</a> to predict the heat pump performance in either cooling or
heating modes.The methodology involved using the generalized least square method to create a set of performance
coefficients from the catalog data at indicated reference conditions. These respective coefficients
and indicated reference conditions are used in the model to simulate the chiller performance.
</p>
<p>
The performance coefficients are stored in the data record <code>per</code> and are available from <a href=\"Buildings.Fluid.Chillers.Data.AbsorptionIndirect\">
Buildings.Fluid.Chillers.Data.AbsorptionIndirect</a>.
</p>
<p>
The model takes as input signals; the set point the leaving water temperature for 
the evaporator which is met if the chiller has sufficient capacity and the Boolean input <code>on</code> which turn on/off the chiller.
</p>
<p>
The electric power only includes the power for the chiller pump.
</p>
</html>", revisions="<html>
<ul>
<li>
July 3, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-140,-100},{140,100}})));
end Absorption_Indirect_HotWater;
