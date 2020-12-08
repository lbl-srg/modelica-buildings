within Buildings.Experimental.DHC.Loads.BaseClasses;
partial model PartialBuildingWithPartialETS
  "Partial model of a building with an energy transfer station"
  import TypDisSys=Buildings.Experimental.DHC.Types.DistrictSystemType
    "District system type enumeration";
  replaceable package Medium1=Modelica.Media.Interfaces.PartialMedium
    "District side medium"
    annotation (choices(choice(redeclare package Medium1=Buildings.Media.Water "Water"),choice(redeclare package Medium1=Buildings.Media.Steam "Steam")));
  replaceable package Medium1b=Medium1
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "District side medium (heating medium leaving ETS)"
    annotation (Dialog(enable=typ == TypDisSys.CombinedGeneration1 or typ == TypDisSys.HeatingGeneration1),choices(choice(redeclare package Medium1b=Buildings.Media.Water "Water")));
  replaceable package Medium1ChiWat=Medium1
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "District side medium (cooling medium)"
    annotation (Dialog(enable=typ == TypDisSys.CombinedGeneration1 or typ == TypDisSys.CombinedGeneration4 or typ == TypDisSys.Cooling),choices(choice(redeclare package Medium1ChiWat=Buildings.Media.Water "Water")));
  replaceable package Medium2=Modelica.Media.Interfaces.PartialMedium
    "Building side medium"
    annotation (choices(choice(redeclare package Medium2=Buildings.Media.Water "Water")));
  parameter Integer nPorts_heaWat=0
    "Number of heating water fluid ports"
    annotation (Evaluate=true);
  parameter Integer nPorts_chiWat=0
    "Number of chilled water fluid ports"
    annotation (Evaluate=true);
  parameter Boolean allowFlowReversal1=false
    "Set to true to allow flow reversal on district side"
    annotation (Dialog(tab="Assumptions"),Evaluate=true);
  parameter Boolean allowFlowReversal2=false
    "Set to true to allow flow reversal on building side"
    annotation (Dialog(tab="Assumptions"),Evaluate=true);
  // The following parameters are propagated up from building and ETS components.
  final parameter TypDisSys typ=ets.typ
    "Type of district system";
  final parameter Boolean have_eleHea=bui.have_eleHea or ets.have_eleHea
    "Set to true if the building or ETS has electric heating equipment"
    annotation (Evaluate=true);
  final parameter Boolean have_eleCoo=bui.have_eleCoo or ets.have_eleCoo
    "Set to true if the building or ETS has electric cooling equipment"
    annotation (Evaluate=true);
  final parameter Boolean have_fan=bui.have_fan or ets.have_fan
    "Set to true if the power drawn by fan motors is computed"
    annotation (Evaluate=true);
  final parameter Boolean have_pum=bui.have_pum or ets.have_pum
    "Set to true if the power drawn by pump motors is computed"
    annotation (Evaluate=true);
  final parameter Boolean have_hotWat=ets.have_hotWat
    "Set to true if the ETS supplies domestic hot water"
    annotation (Evaluate=true);
  final parameter Boolean have_weaBus=bui.have_weaBus or ets.have_weaBus
    "Set to true for weather bus"
    annotation (Evaluate=true);
  final parameter Modelica.SIunits.HeatFlowRate QChiWat_flow_nominal=ets.QChiWat_flow_nominal
    "Design heat flow rate for chilled water production (<0)"
    annotation (Dialog(group="Nominal condition",enable=have_chiWat));
  final parameter Modelica.SIunits.HeatFlowRate QHeaWat_flow_nominal=ets.QHeaWat_flow_nominal
    "Design heat flow rate for heating water production (>0)"
    annotation (Dialog(group="Nominal condition",enable=have_heaWat));
  final parameter Modelica.SIunits.HeatFlowRate QHotWat_flow_nominal=ets.QHotWat_flow_nominal
    "Design heat flow rate for hot water production (>0)"
    annotation (Dialog(group="Nominal condition",enable=have_hotWat));
  // Parameters for connect clauses.
  final parameter Integer idxPHeaETS=max(
    Modelica.Math.BooleanVectors.countTrue(
      {bui.have_eleHea,ets.have_eleHea}),
    1)
    "Index for connecting the ETS output connector"
    annotation (Evaluate=true);
  final parameter Integer idxPCooETS=max(
    Modelica.Math.BooleanVectors.countTrue(
      {bui.have_eleCoo,ets.have_eleCoo}),
    1)
    "Index for connecting the ETS output connector"
    annotation (Evaluate=true);
  final parameter Integer idxPFanETS=max(
    Modelica.Math.BooleanVectors.countTrue(
      {bui.have_fan,ets.have_fan}),
    1)
    "Index for connecting the ETS output connector"
    annotation (Evaluate=true);
  final parameter Integer idxPPumETS=max(
    Modelica.Math.BooleanVectors.countTrue(
      {bui.have_pum,ets.have_pum}),
    1)
    "Index for connecting the ETS output connector"
    annotation (Evaluate=true);
  // IO CONNECTORS
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(
    redeclare package Medium=Medium1,
    m_flow(
      min=
        if allowFlowReversal1 then
          -Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium1.h_default,
      nominal=Medium1.h_default)) if typ <> TypDisSys.Cooling
    "Fluid connector for district water supply"
    annotation (Placement(transformation(extent={{-150,-90},{-130,-70}}),iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(
    redeclare package Medium=Medium1b,
    m_flow(
      max=
        if allowFlowReversal1 then
          +Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium1b.h_default,
      nominal=Medium1b.h_default)) if typ <> TypDisSys.Cooling
    "Fluid connector for district water return"
    annotation (Placement(transformation(extent={{130,-90},{150,-70}}),iconTransformation(extent={{90,-10},{110,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1ChiWat(
    redeclare package Medium=Medium1ChiWat,
    m_flow(
      min=
        if allowFlowReversal1 then
          -Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium1ChiWat.h_default,
      nominal=Medium1ChiWat.h_default)) if typ == TypDisSys.CombinedGeneration1 or typ == TypDisSys.CombinedGeneration4 or typ == TypDisSys.Cooling
    "Fluid connector for district water supply"
    annotation (Placement(transformation(extent={{-150,-130},{-130,-110}}),iconTransformation(extent={{-110,-50},{-90,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1ChiWat(
    redeclare package Medium=Medium1ChiWat,
    m_flow(
      max=
        if allowFlowReversal1 then
          +Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium1ChiWat.h_default,
      nominal=Medium1ChiWat.h_default)) if typ == TypDisSys.CombinedGeneration1 or typ == TypDisSys.CombinedGeneration4 or typ == TypDisSys.Cooling
    "Fluid connector for district water return"
    annotation (Placement(transformation(extent={{130,-130},{150,-110}}),iconTransformation(extent={{90,-50},{110,-30}})));
  BoundaryConditions.WeatherData.Bus weaBus if have_weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-20,100},{20,140}}),iconTransformation(extent={{-10,58},{10,78}})));
  // COMPONENTS
  replaceable DHC.Loads.BaseClasses.PartialBuilding bui(
    redeclare final package Medium=Medium2,
    final nPorts_aHeaWat=nPorts_heaWat,
    final nPorts_bHeaWat=nPorts_heaWat,
    final nPorts_aChiWat=nPorts_chiWat,
    final nPorts_bChiWat=nPorts_chiWat,
    final allowFlowReversal=allowFlowReversal2)
    "Building model "
    annotation (Placement(transformation(extent={{-30,8},{30,68}})));
  replaceable DHC.EnergyTransferStations.BaseClasses.PartialETS ets(
    redeclare final package Medium2=Medium2,
    redeclare final package Medium1=Medium1,
    final nPorts_aHeaWat=nPorts_heaWat,
    final nPorts_bHeaWat=nPorts_heaWat,
    final nPorts_aChiWat=nPorts_chiWat,
    final nPorts_bChiWat=nPorts_chiWat,
    final allowFlowReversal2=allowFlowReversal2,
    final allowFlowReversal1=allowFlowReversal1)
    "Energy transfer station model"
    annotation (Placement(transformation(extent={{-30,-84},{30,-24}})));
  Modelica.Blocks.Interfaces.RealOutput QHea_flow(
    final unit="W") if bui.have_heaLoa
    "Total heating heat flow rate transferred to the loads (>=0)"
    annotation (Placement(transformation(extent={{140,110},{180,150}}),iconTransformation(extent={{-10,-10},{10,10}},rotation=-90,origin={70,-110})));
  Modelica.Blocks.Interfaces.RealOutput QCoo_flow(
    final unit="W") if bui.have_cooLoa
    "Total cooling heat flow rate transferred to the loads (<=0)"
    annotation (Placement(transformation(extent={{140,90},{180,130}}),iconTransformation(extent={{-10,-10},{10,10}},rotation=-90,origin={90,-110})));
  Modelica.Blocks.Interfaces.RealOutput PHea(
    final unit="W") if have_eleHea
    "Power drawn by heating equipment"
    annotation (Placement(transformation(extent={{140,70},{180,110}}),iconTransformation(extent={{100,80},{120,100}})));
  Modelica.Blocks.Interfaces.RealOutput PCoo(
    final unit="W") if have_eleCoo
    "Power drawn by cooling equipment"
    annotation (Placement(transformation(extent={{140,50},{180,90}}),iconTransformation(extent={{100,60},{120,80}})));
  Modelica.Blocks.Interfaces.RealOutput PFan(
    final unit="W") if have_fan
    "Power drawn by fan motors"
    annotation (Placement(transformation(extent={{140,30},{180,70}}),iconTransformation(extent={{100,40},{120,60}})));
  Modelica.Blocks.Interfaces.RealOutput PPum(
    final unit="W") if have_pum
    "Power drawn by pump motors"
    annotation (Placement(transformation(extent={{140,10},{180,50}}),iconTransformation(extent={{100,20},{120,40}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPHea(
    final nin=Modelica.Math.BooleanVectors.countTrue(
      {bui.have_eleHea,ets.have_eleHea}))
    "Total power drawn by heating equipment"
    annotation (Placement(transformation(extent={{110,80},{130,100}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPCoo(
    final nin=Modelica.Math.BooleanVectors.countTrue(
      {bui.have_eleCoo,ets.have_eleCoo}))
    "Total power drawn by cooling equipment"
    annotation (Placement(transformation(extent={{90,60},{110,80}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPFan(
    final nin=Modelica.Math.BooleanVectors.countTrue(
      {bui.have_fan,ets.have_fan}))
    "Total power drawn by fan motors"
    annotation (Placement(transformation(extent={{110,40},{130,60}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPPum(
    final nin=Modelica.Math.BooleanVectors.countTrue(
      {bui.have_pum,ets.have_pum}))
    "Total power drawn by pump motors"
    annotation (Placement(transformation(extent={{90,20},{110,40}})));
equation
  connect(bui.ports_bHeaWat,ets.ports_aHeaWat)
    annotation (Line(points={{30,32},{54,32},{54,-14},{-60,-14},{-60,-28},{-30,-28}},color={0,127,255}));
  connect(ets.ports_bHeaWat,bui.ports_aHeaWat)
    annotation (Line(points={{30,-28},{60,-28},{60,0},{-60,0},{-60,32},{-30,32}},color={0,127,255}));
  connect(bui.ports_bChiWat,ets.ports_aChiWat)
    annotation (Line(points={{30,20},{40,20},{40,-20},{-40,-20},{-40,-38},{-30,-38}},color={0,127,255}));
  connect(ets.ports_bChiWat,bui.ports_aChiWat)
    annotation (Line(points={{30,-38},{46,-38},{46,-8},{-40,-8},{-40,20},{-30,20}},color={0,127,255}));
  connect(weaBus,bui.weaBus)
    annotation (Line(points={{0,120},{0,90},{0,59.4},{0.1,59.4}},color={255,204,51},thickness=0.5),Text(string="%first",index=-1,extent={{-3,6},{-3,6}},horizontalAlignment=TextAlignment.Right));
  connect(weaBus,ets.weaBus)
    annotation (Line(points={{0,120},{0,72},{4,72},{4,-26},{0.1,-26},{0.1,-27.4}},color={255,204,51},thickness=0.5),Text(string="%first",index=-1,extent={{-3,6},{-3,6}},horizontalAlignment=TextAlignment.Right));
  connect(bui.QHea_flow,QHea_flow)
    annotation (Line(points={{32,64},{40,64},{40,130},{160,130}},color={0,0,127}));
  connect(bui.QCoo_flow,QCoo_flow)
    annotation (Line(points={{32,60},{46,60},{46,110},{160,110}},color={0,0,127}));
  connect(totPHea.y,PHea)
    annotation (Line(points={{132,90},{160,90}},color={0,0,127}));
  connect(totPCoo.y,PCoo)
    annotation (Line(points={{112,70},{160,70}},color={0,0,127}));
  connect(totPFan.y,PFan)
    annotation (Line(points={{132,50},{160,50}},color={0,0,127}));
  connect(totPPum.y,PPum)
    annotation (Line(points={{112,30},{160,30}},color={0,0,127}));
  connect(bui.PHea,totPHea.u[1])
    annotation (Line(points={{32,56},{60,56},{60,90},{108,90}},color={0,0,127}));
  connect(ets.PHea,totPHea.u[idxPHeaETS])
    annotation (Line(points={{32,-48},{62,-48},{62,90},{108,90}},color={0,0,127}));
  connect(bui.PCoo,totPCoo.u[1])
    annotation (Line(points={{32,52},{64,52},{64,70},{88,70}},color={0,0,127}));
  connect(ets.PCoo,totPCoo.u[idxPCooETS])
    annotation (Line(points={{32,-52},{66,-52},{66,70},{88,70}},color={0,0,127}));
  connect(bui.PFan,totPFan.u[1])
    annotation (Line(points={{32,48},{68,48},{68,50},{108,50}},color={0,0,127}));
  connect(ets.PFan,totPFan.u[idxPFanETS])
    annotation (Line(points={{32,-56},{70,-56},{70,50},{108,50}},color={0,0,127}));
  connect(bui.PPum,totPPum.u[1])
    annotation (Line(points={{32,44},{72,44},{72,30},{88,30}},color={0,0,127}));
  connect(ets.PPum,totPPum.u[idxPPumETS])
    annotation (Line(points={{32,-60},{74,-60},{74,30},{88,30}},color={0,0,127}));
  connect(port_a1,ets.port_a1)
    annotation (Line(points={{-140,-80},{-60,-80},{-60,-76},{-30,-76}},color={0,127,255}));
  connect(port_a1ChiWat,ets.port_a1ChiWat)
    annotation (Line(points={{-140,-120},{-40,-120},{-40,-82},{-30,-82}},color={0,127,255}));
  connect(ets.port_b1ChiWat,port_b1ChiWat)
    annotation (Line(points={{30,-82},{40,-82},{40,-120},{140,-120}},color={0,127,255}));
  connect(ets.port_b1,port_b1)
    annotation (Line(points={{30,-76},{60,-76},{60,-80},{140,-80}},color={0,127,255}));
  annotation (
    DefaultComponentName="bui",
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-60,-34},{0,-28}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,-34},{0,-40}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-40},{60,-34}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-28},{60,-34}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{60,6},{100,0}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,0},{-60,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,0},{-60,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{60,-6},{100,0}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,80},{-40,60},{40,60},{0,80}},
          lineColor={95,95,95},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95}),
        Rectangle(
          extent={{-40,60},{40,-40}},
          lineColor={150,150,150},
          fillPattern=FillPattern.Sphere,
          fillColor={255,255,255}),
        Rectangle(
          extent={{-30,30},{-10,50}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,30},{30,50}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,-10},{-10,10}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,-10},{30,10}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0}),
        Rectangle(
          extent={{-20,-3},{20,3}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={63,-20},
          rotation=90),
        Rectangle(
          extent={{-19,3},{19,-3}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-63,-21},
          rotation=90),
        Rectangle(
          extent={{-19,-3},{19,3}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={-57,-13},
          rotation=90),
        Rectangle(
          extent={{-19,3},{19,-3}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={57,-13},
          rotation=90)}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-140,-140},{140,140}})));
end PartialBuildingWithPartialETS;
