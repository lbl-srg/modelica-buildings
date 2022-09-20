within Buildings.Templates.ChilledWaterPlants.Components.Validation;
model TestRecordArray
  extends Modelica.Icons.Example;

  record SingleChillerRecord
    parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal=30
      "CHW mass flow rate for each chiller";
    parameter Modelica.Units.SI.MassFlowRate mConWatChi_flow_nominal=30
      "CW mass flow rate for each water-cooled chiller";
    parameter Modelica.Units.SI.HeatFlowRate capChi_nominal=1E6
      "Cooling capacity for each chiller (>0)";
    parameter Modelica.Units.SI.Temperature TChiWatSup_nominal=7+273.15
      "CHW supply temperature";
    parameter Modelica.Units.SI.Temperature TConWatSup_nominal=30+273.15
      "CW supply temperature";
    replaceable parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic per
      constrainedby Buildings.Fluid.Chillers.Data.BaseClasses.Chiller(
        QEva_flow_nominal=-1*capChi_nominal,
        TEvaLvg_nominal=TChiWatSup_nominal,
        TEvaLvgMin=TChiWatSup_nominal,
        TEvaLvgMax=16+273.15,
        PLRMin=0.15,
        PLRMinUnl=0.15,
        mEva_flow_nominal=mChiWatChi_flow_nominal,
        mCon_flow_nominal=mConWatChi_flow_nominal);
  end SingleChillerRecord;

  record ChillerGroupRecord
    parameter Integer nChi=3
      "Number of chillers";
    parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal[nChi]=fill(30,nChi)
      "CHW mass flow rate for each chiller";
    parameter Modelica.Units.SI.MassFlowRate mConWatChi_flow_nominal[nChi]=fill(30,nChi)
      "CW mass flow rate for each water-cooled chiller";
    parameter Modelica.Units.SI.HeatFlowRate capChi_nominal[nChi]=fill(1E6,nChi)
      "Cooling capacity for each chiller (>0)";
    parameter Modelica.Units.SI.Temperature TChiWatSup_nominal=7+273.15
      "CHW supply temperature";
    parameter Modelica.Units.SI.Temperature TConWatSup_nominal=30+273.15
      "CW supply temperature";
    replaceable parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic per[nChi]
      constrainedby Buildings.Fluid.Chillers.Data.BaseClasses.Chiller(
        QEva_flow_nominal=-1*capChi_nominal,
        TEvaLvg_nominal=fill(TChiWatSup_nominal, nChi),
        TEvaLvgMin=fill(TChiWatSup_nominal, nChi),
        TEvaLvgMax=fill(16+273.15, nChi),
        PLRMin=fill(0.15, nChi),
        PLRMinUnl=fill(0.15, nChi),
        mEva_flow_nominal=mChiWatChi_flow_nominal,
        mCon_flow_nominal=mConWatChi_flow_nominal);
    final parameter SingleChillerRecord datChi[nChi](
      final mChiWatChi_flow_nominal=mChiWatChi_flow_nominal,
      final mConWatChi_flow_nominal=mConWatChi_flow_nominal,
      final capChi_nominal=capChi_nominal,
      final TChiWatSup_nominal=fill(TChiWatSup_nominal, nChi),
      final per=per);
  end ChillerGroupRecord;

  model M
    replaceable parameter ChillerGroupRecord rec
      constrainedby ChillerGroupRecord;
  end M;

  ChillerGroupRecord rec(
    redeclare each Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YCAL0033EE_101kW_3_1COP_AirCooled per);

  M mod(rec=rec);
end TestRecordArray;
