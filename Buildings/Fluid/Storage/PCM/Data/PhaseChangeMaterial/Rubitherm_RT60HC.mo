within Buildings.Fluid.Storage.PCM.Data.PhaseChangeMaterial;
package Rubitherm_RT60HC "Rubitherm GmbH, RT60HC; data taken from: Rubitherm datasheet."
  extends  slPCMlib.Interfaces.partialPCM;

  // ----------------------------------
  redeclare replaceable record propData "PCM record"

    constant String mediumName = "RT60HC";
    // --- parameters for phase transition functions ---
    constant Boolean modelForMelting =        true;
    constant Boolean modelForSolidification = true;
    constant Modelica.Units.SI.Temperature rangeTmelting[2] = {3.2314999999999998E+02, 3.3614999999999998E+02}
             "temperature range melting {startT, endT}";
    constant Modelica.Units.SI.Temperature rangeTsolidification[2] = {3.2414999999999998E+02, 3.3514999999999998E+02}
             "temperature range solidification {startT, endT}";

    // --- parameters for heat capacity and enthalpy ---
    constant Modelica.Units.SI.SpecificHeatCapacity[2] cpS_linCoef = {2.0000000000000000E+03, 0.0000000000000000E+00}
             "solid specific heat capacity, linear coefficients a + b*T";
    constant Modelica.Units.SI.SpecificHeatCapacity[2] cpL_linCoef = {2.0000000000000000E+03, 0.0000000000000000E+00}
             "liquid specific heat capacity, linear coefficients a + b*T";
    constant Modelica.Units.SI.SpecificEnthalpy   phTrEnth = 2.6452741843501542E+05
             "scalar phase transition enthalpy";

    // --- reference values ---
    constant Modelica.Units.SI.Temperature  Tref = rangeTmelting[1]
             "reference temperature";
    constant Modelica.Units.SI.SpecificEnthalpy  href = 0.0
             "reference enthalpy at Tref";

  end propData;


  // ----------------------------------
  redeclare function extends phaseFrac_complMelting
    "Returns liquid mass phase fraction for complete melting processes"
  protected
    constant Integer len_x =    data_H.len_x;
    constant Real data_x[:] =   data_H.data_x;
    constant Real data_y[:] =   data_H.data_y;
    constant Real m_k[:] =      data_H.m_k;
    constant Real iy_start[:] = data_H.iy_start;
    constant Real iy_scaler =   data_H.iy_scaler;
  algorithm
    (xi, dxi) := slPCMlib.BasicUtilities.cubicHermiteSplineEval(T-273.15,
                 len_x, data_x, data_y, m_k, iy_start, iy_scaler);
  end phaseFrac_complMelting;

  // ----------------------------------
  redeclare function extends phaseFrac_complSolidification
    "Returns liquid mass phase fraction for complete solidification processes"
  protected
    constant Integer len_x =    data_C.len_x;
    constant Real data_x[:] =   data_C.data_x;
    constant Real data_y[:] =   data_C.data_y;
    constant Real m_k[:] =      data_C.m_k;
    constant Real iy_start[:] = data_C.iy_start;
    constant Real iy_scaler =   data_C.iy_scaler;
  algorithm
    (xi, dxi) := slPCMlib.BasicUtilities.cubicHermiteSplineEval(T-273.15,
                 len_x, data_x, data_y, m_k, iy_start, iy_scaler);
  end phaseFrac_complSolidification;

  // ----------------------------------
  package data_H "spline interpolation data for heating"
    extends Modelica.Icons.Package;
    constant Integer  len_x =    14;
    constant Real[14] data_x =   {5.0000000000000000E+01, 5.2625000000000000E+01, 5.4875000000000000E+01, 5.6625000000000000E+01, 5.8625000000000000E+01, 5.9875000000000000E+01, 6.0375000000000000E+01, 6.0625000000000000E+01, 6.0875000000000000E+01, 6.1125000000000000E+01, 6.1625000000000000E+01, 6.1875000000000000E+01, 6.2875000000000000E+01, 6.3000000000000000E+01};
    constant Real[14] data_y =   {0.0000000000000000E+00, 1.2768133011999999E-02, 3.0590439165999999E-02, 3.1892708887999999E-02, 8.1894258654999996E-02, 1.8696226150299999E-01, 3.4794026749599999E-01, 4.9334748718600002E-01, 5.2575078416099996E-01, 4.2847607736799997E-01, 8.0679170413999995E-02, 2.7444280046999999E-02, 0.0000000000000000E+00, 0.0000000000000000E+00};
    constant Real[14] m_k =      {0.0000000000000000E+00, -7.7469021709999997E-03, 1.3460511043999999E-02, 2.0528986514000001E-02, 1.4122573055000000E-02, 1.9670756622700000E-01, 4.3056625883200000E-01, 4.5832549208200002E-01, -1.7171492437800001E-01, -6.9228207596699998E-01, -5.7698655226600004E-01, -8.0073094742000001E-02, 0.0000000000000000E+00, 0.0000000000000000E+00};
    constant Real[14] iy_start = {0.0000000000000000E+00, 2.1132995318000000E-02, 6.0826279545999999E-02, 1.1351162332700000E-01, 2.2903176267100001E-01, 3.7279235327900001E-01, 5.0119875362400002E-01, 6.0585069281799997E-01, 7.3606596203700003E-01, 8.5763225187900005E-01, 9.8208566423599997E-01, 9.9297508217700003E-01, 1.0000000000000000E+00, 1.0000000000000000E+00};
    constant Real    iy_scaler = 9.9652958170012729E-01;
  end data_H;

  // ----------------------------------
  package data_C "spline interpolation data for cooling"
    extends Modelica.Icons.Package;
    constant Integer  len_x =    14;
    constant Real[14] data_x =   {5.1000000000000000E+01, 5.2625000000000000E+01, 5.3875000000000000E+01, 5.4375000000000000E+01, 5.5625000000000000E+01, 5.8125000000000000E+01, 5.9625000000000000E+01, 6.0375000000000000E+01, 6.0625000000000000E+01, 6.1125000000000000E+01, 6.1375000000000000E+01, 6.1625000000000000E+01, 6.1875000000000000E+01, 6.2000000000000000E+01};
    constant Real[14] data_y =   {0.0000000000000000E+00, 1.4736759388000001E-02, 0.0000000000000000E+00, 0.0000000000000000E+00, 1.5737160898000001E-02, 4.3312001300999999E-02, 1.0465501299400000E-01, 3.3803301742600000E-01, 5.4514013709499998E-01, 6.1448961256099999E-01, 4.4475389374399998E-01, 2.2306507387899999E-01, 5.1183912927000003E-02, 0.0000000000000000E+00};
    constant Real[14] m_k =      {0.0000000000000000E+00, 1.6391962816000000E-02, 0.0000000000000000E+00, 0.0000000000000000E+00, -3.7300167919999999E-03, 2.0937060800999999E-02, 9.8497598145999996E-02, 6.0352447422099997E-01, 6.8507492198300002E-01, -5.4392229271000003E-01, -8.2925240799199995E-01, -8.0154120984300004E-01, -5.9651664761699996E-01, 0.0000000000000000E+00};
    constant Real[14] iy_start = {0.0000000000000000E+00, 8.2992418110000004E-03, 1.9552843239000001E-02, 1.9552843239000001E-02, 2.9791235958000001E-02, 9.0264936278000002E-02, 1.8592201589099999E-01, 3.2711213370199999E-01, 4.3619956348400002E-01, 7.4917354024000005E-01, 8.8198822150300005E-01, 9.6465103943300001E-01, 9.9759720153499998E-01, 1.0000000000000000E+00};
    constant Real    iy_scaler = 9.9195728546595674E-01;
  end data_C;

  // ----------------------------------
  redeclare function extends density_solid "Returns solid density"
  algorithm
    rho := 8.5000000000000000E+02;
  end density_solid;
  // ----------------------------------
  redeclare function extends density_liquid "Returns liquid density"
  algorithm
    rho := 7.5000000000000000E+02;
  end density_liquid;
  // ----------------------------------
  redeclare function extends conductivity_solid "Returns solid thermal conductivity"
  algorithm
    lambda := 2.0000000000000001E-01;
  end conductivity_solid;
  // ----------------------------------
  redeclare function extends conductivity_liquid "Returns liquid thermal conductivity"
  algorithm
    lambda := 2.0000000000000001E-01;
  end conductivity_liquid;


annotation(Documentation(
  info="<html>
  <p>
  This package contains solid and liquid properties for the PCM:  <strong>RT60HC</strong>  from manufacturer: <strong>Rubitherm GmbH</strong>.<br>
  Basic characteristics are the material class: unknown, and encapsulation: multiple options available<br>  The data is taken from: Rubitherm datasheet - last access 2023-05-23.<br><br>
  <br><br>
  The package contains phase transition functions for
  <ul>
  <li>complete melting       :  true</li>
  <li>complete solidification:  true</li>
  </ul></p><p>
  <p>
   Code export from <strong><u>slPCMlib database</u></strong> on 2023-12-08.<br><br>
   See:<br>
    Barz, T., Bres, A., & Emhofer, J. (2022).
    slPCMlib: A Modelica Library for the Prediction of Effective 
    Thermal Material Properties of Solid/Liquid Phase Change  
    Materials (PCM). 
    In Proceedings of Asian Modelica Conference 2022 (pp. 63-74). 
    Linkoping University Electronic Press. 
    <a href>https://doi.org/10.3384/ecp19363</a>.
    </p>
    </blockquote>
    </p></html>",
    revisions="<html>
    <ul>
    <li>file creation date: 2023-12-08 </ul>
    </p></html>"));
end Rubitherm_RT60HC;
