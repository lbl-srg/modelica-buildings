within Buildings.Templates.Components.Chillers.Interfaces;
partial model PartialChiller "Partial chiller model"

  replaceable package MediumChiWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium";
  replaceable package MediumConWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CW medium";

  parameter Integer nChi
    "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.ChilledWaterPlants.Types.Chiller typ
    "Type of chiller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.ChilledWaterPlants.Types.ChillerCompressor typCom[nChi](
    each start=Buildings.Templates.ChilledWaterPlants.Types.ChillerCompressor.ConstantSpeed)
    "Type of compressor"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.ChilledWaterPlants.Types.ChillerLift typCtrHea[nChi](
    each start=Buildings.Templates.ChilledWaterPlants.Types.ChillerLift.None)
    "Type of head pressure control"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typ==Buildings.Templates.ChilledWaterPlants.Types.Chiller.WaterCooled));

  parameter Buildings.Templates.ChilledWaterPlants.Types.ValveOption typOptValConWatIso
    "Possible options for chiller CW isolation valve"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.ChilledWaterPlants.Types.ValveOption typOptValChiWatIso
    "Possible options for chiller CHW isolation valve"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.Chillers dat(
    final typ=typ)
    "Chiller data";

  Modelica.Fluid.Interfaces.FluidPorts_b ports_bChiWat[nChi](
    redeclare each final package Medium = Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Chiller CHW supply" annotation (Placement(transformation(extent={{-170,-140},
            {-150,-60}}), iconTransformation(extent={{-210,-340},{-190,-260}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bConWat[nChi](
    redeclare each final package Medium = Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Chiller CW return (from chillers to cooling towers)" annotation (Placement(
        transformation(extent={{150,80},{170,160}}), iconTransformation(extent={
            {188,260},{208,340}})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aConWat[nChi](
    redeclare each final package Medium = Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Chiller CW supply (from cooling towers to chillers)" annotation (Placement(
        transformation(extent={{-170,80},{-150,160}}), iconTransformation(
          extent={{-210,260},{-190,340}})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aChiWat[nChi](
    redeclare each final package Medium = Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Chiller CHW return" annotation (Placement(transformation(extent={{150,-140},
            {170,-60}}), iconTransformation(extent={{-210,260},{-190,340}})));

  Buildings.Templates.Components.Interfaces.Bus bus[nChi]
    "Control bus"
    annotation (Placement(transformation(
          extent={{-20,140},{20,180}}), iconTransformation(extent={{-20,580},{
            20,620}})));


  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},
            {160,160}}),
    graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{160,160}})));
end PartialChiller;
