#!/usr/bin/env python3

import energyplus_csv_to_mos as e

if __name__ == '__main__':

    dat_fil = "RefBldgSmallOffice.dat"
    output_list = [
           "Environment:Site Outdoor Air Drybulb Temperature [C](TimeStep)",
           "Environment:Site Outdoor Air Relative Humidity [%](TimeStep)",
           "ATTIC:Zone Mean Air Temperature [C](TimeStep)",
           "CORE_ZN:Zone Mean Air Temperature [C](TimeStep)",
           "PERIMETER_ZN_1:Zone Mean Air Temperature [C](TimeStep)",
           "PERIMETER_ZN_2:Zone Mean Air Temperature [C](TimeStep)",
           "PERIMETER_ZN_3:Zone Mean Air Temperature [C](TimeStep)",
           "PERIMETER_ZN_4:Zone Mean Air Temperature [C](TimeStep)"
      ]

    e.energyplus_csv_to_mos(output_list = output_list, dat_file_name=dat_fil)
