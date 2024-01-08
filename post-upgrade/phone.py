import phonenumbers
import re
from phonenumbers import geocoder, carrier

def onlynumbers(texto):
    return re.sub(r'\D', '', texto)

def phone_validation(input_number, language='pt-br'):
    """
    Validação e obtenção de informações para um número de telefone.

    Args:
        input_number (str): Número de telefone a ser validado e analisado.
        language (str): Idioma para informações de localidade e provedor de serviços.
                        Padrão é 'pt-br' (português brasileiro).

    Returns:
        dict: Um dicionário contendo informações sobre o número de telefone.
            As chaves incluem:
                - 'possible': True se o número é possível, False caso contrário.
                - 'valid': True se o número é válido, False caso contrário.
                - 'formatted': Número de telefone formatado no padrão internacional.
                - 'carrier': Nome do provedor de serviços do número (no idioma especificado).
                - 'locale': Descrição da localidade associada ao número (no idioma especificado).
                - 'type': Tipo do número de telefone (móvel, fixo, etc.).
    """
    # Dicionário para armazenar informações do número de telefone
    phone_data = {}
    try:
        # Analisa o número de telefone usando a biblioteca phonenumbers
        number = phonenumbers.parse(input_number, None)
        #print("o numero: ", number)

        # Verifica se o número é possível e válido
        phone_data['possible'] = phonenumbers.is_possible_number(number)
        phone_data['valid'] = phonenumbers.is_valid_number(number)

        # Formata o número no padrão internacional
        phone_data['formatted'] = phonenumbers.format_number(number, phonenumbers.PhoneNumberFormat.INTERNATIONAL)

        # Obtém o nome do provedor de serviços do número
        phone_data['carrier'] = carrier.name_for_number(number, language)

        # Obtém a descrição da localidade associada ao número
        phone_data['locale'] = geocoder.description_for_number(number, language)

        # Obtém o tipo do número de telefone (móvel, fixo, etc.)
        phone_data['type'] = phonenumbers.phonenumberutil.number_type(number)

    except phonenumbers.NumberParseException:
        # Se a entrada não for um número de telefone válido, trata o erro
        phone_data['possible'] = False
        phone_data['valid'] = False

    return phone_data


def validate_and_sanitize(phone_number):

    update, valid, finalnumber = False, False, ""

    if phone_number.startswith('+'):
        phone_data = phone_validation(phone_number)
        if not phone_data['valid']:
            update, valid, finalnumber = False, False, ""
        else:
            #adjnumbers.append(phone_data['formatted'])
            update, valid, finalnumber = False, True, ""
    else:
        numeric_chars = onlynumbers(phone_number)
        if len(numeric_chars) < 10:
            update, valid, finalnumber = False, False, ""
        elif len(numeric_chars) == 10:
            if int(numeric_chars[2]) < 7:
                new_phone = '+55' + phone_number
                phone_data = phone_validation(new_phone)
                if not phone_data['valid']:
                    update, valid, finalnumber = False, False, ""
                else:
                    update, valid, finalnumber = True, True, phone_data['formatted']
            else:
                new_phone = '+55' + numeric_chars[:2] + '9' + numeric_chars[2:]
                phone_data = phone_validation(new_phone)
                if not phone_data['valid']:
                    update, valid, finalnumber = False, False, ""
                else:
                    update, valid, finalnumber = True, True, phone_data['formatted']
        elif len(numeric_chars) == 11:
            new_phone = '+55' + phone_number
            phone_data = phone_validation(new_phone)
            if not phone_data['valid']:
                update, valid, finalnumber = False, False, ""
            else:
                update, valid, finalnumber = True, True, phone_data['formatted']
        elif len(numeric_chars) > 11:
            update, valid, finalnumber = False, False, ""

    if update and valid: return finalnumber
    return False
