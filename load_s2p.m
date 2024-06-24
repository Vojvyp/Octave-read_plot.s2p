## Copyright (C) 2023 vyplel
## Author: vyplel <vyplel@VVU166>
## Created: 2023-12-07
## function for open s2p files

function [freq, s11, s12, s21, s22] = load_s2p(file_name)
fid = fopen ([file_name, '.s2p'], "rt");
text_after_hash = {};
while ~feof(fid)
    line = fgetl(fid);
    % Přeskočte řádky obsahující znak '!'
    if isempty(strfind(line, '!'))
        % Najděte pozici znaku '#'
        hash_position = strfind(line, '#');

        % Pokud znak '#' existuje v řádce, získejte text za ním
        if ~isempty(hash_position)
            text_after_hash{end+1} = line(hash_position+1:end);
        end
    end
    matches = regexp(text_after_hash, '(DB|MA|RI)', 'match', 'ignorecase');
    #calculation of S parameters according to s2p file data type
    for i = 1:length(matches)
    match = matches{i};
    freq = [];
    s11 = [];
    s12 = [];
    s21 = [];
    s22 = [];
    if strcmpi(match, 'MA') # Linear Magnitude/Degree Angle (polar form)

      s11_mag = [];
      s11_ang = [];
      s21_mag = [];
      s21_ang = [];
      s12_mag = [];
      s12_ang = [];
      s22_mag = [];
      s22_ang = [];
      while (! feof (fid))
        str = fgets (fid);
        [val , len]= sscanf (str,'%f');
        ## Ignore lines with less than 9 elements
        if (len == 9)
          freq = [freq; val(1)];
          s11_mag = [s11_mag; val(2)];
          s11_ang = [s11_ang; val(3)];
          s21_mag = [s21_mag; val(4)];
          s21_ang = [s21_ang; val(5)];
          s12_mag = [s12_mag; val(6)];
          s12_ang = [s12_ang; val(7)];
          s22_mag = [s22_mag; val(8)];
          s22_ang = [s22_ang; val(9)];
        endif
      endwhile
      #S_parameter[dB] = 20 * Log(sqr(mag*cos(angle))^2 + (mag*sin(angle))^2))
      s11 = 20*log10(sqrt((s11_mag.*cos(s11_ang)).^2+(s11_mag.*sin(s11_ang)).^2));
      s21 = 20*log10(sqrt((s21_mag.*cos(s21_ang)).^2+(s21_mag.*sin(s21_ang)).^2));
      s12 = 20*log10(sqrt((s12_mag.*cos(s12_ang)).^2+(s12_mag.*sin(s12_ang)).^2));
      s22 = 20*log10(sqrt((s22_mag.*cos(s22_ang)).^2+(s22_mag.*sin(s22_ang)).^2));
    elseif strcmpi(match, 'RI') # Real Part/Imaginary Part (rectangular form)

      s11_re = [];
      s11_im = [];
      s21_re = [];
      s21_im = [];
      s12_re = [];
      s12_im = [];
      s22_re = [];
      s22_im = [];
      while (! feof (fid))
        str = fgets (fid);
        [val , len]= sscanf (str,'%f');
        ## Ignore lines with less than 9 elements
        if (len == 9)
          freq = [freq; val(1)];
          s11_re = [s11_re; val(2)];
          s11_im = [s11_im; val(3)];
          s21_re = [s21_re; val(4)];
          s21_im = [s21_im; val(5)];
          s12_re = [s12_re; val(6)];
          s12_im = [s12_im; val(7)];
          s22_re = [s22_re; val(8)];
          s22_im = [s22_im; val(9)];
        endif
      endwhile
      #S_parameter[dB] = 20 * Log(sqr(Re^2 + Im^2))
      s11 = 20*log10(sqrt(s11_re.^2+s11_im.^2));
      s21 = 20*log10(sqrt(s21_re.^2+s21_im.^2));
      s12 = 20*log10(sqrt(s12_re.^2+s12_im.^2));
      s22 = 20*log10(sqrt(s22_re.^2+s22_im.^2));
    else #Decibel Magnitude/Degree Angle
      while (! feof (fid))
        str = fgets (fid);
        [val , len]= sscanf (str,'%f');
        ## Ignore lines with less than 9 elements
        if (len == 9)
          freq = [freq; val(1)];
          s11 = [s11; val(2)];
          s21 = [s21; val(4)];
          s12 = [s12; val(6)];
          s22 = [s22; val(8)];
        endif
      endwhile
    end
    end
    % Nalezněte všechny shody s regulárním výrazem pro "hz", "HZ" nebo "MHz" (ignorujte velikost písmen)
    matches = regexp(text_after_hash, '(hz|HZ|MHz|GHz)', 'match', 'ignorecase');
    % Zpracujte nalezené shody
    for i = 1:length(matches)
    match = matches{i};
      if strcmpi(match, 'hz')
          freq=freq/1000000;
      elseif strcmpi(match, 'ghz')
          freq=freq*1000;
      else

      end
    end
end
% Zavře soubor
fclose(fid);
endfunction
