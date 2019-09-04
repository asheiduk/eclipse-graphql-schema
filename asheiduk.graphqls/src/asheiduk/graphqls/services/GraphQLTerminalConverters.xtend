package asheiduk.graphqls.services

import org.eclipse.xtext.conversion.IValueConverter
import org.eclipse.xtext.conversion.ValueConverter
import org.eclipse.xtext.conversion.ValueConverterException
import org.eclipse.xtext.conversion.impl.AbstractDeclarativeValueConverterService
import org.eclipse.xtext.nodemodel.INode

// Int is not handled by the  default Xtext converter (INTValueConverter) it does not support negative numbers.
// Float is not handled by Xtext at all. But both are -- presumable -- handled by EMF converters.
class GraphQLTerminalConverters extends AbstractDeclarativeValueConverterService {
	
	@ValueConverter(rule = "STRING")
	def STRING(){
		return new IValueConverter<String> {
			override toString(String value) throws ValueConverterException {
				if( value === null )
					return null
				if( value.indexOf('\n') < 0 )
					return '''"«value»"'''
				return '''"""«value»"""'''
			}
			
			override toValue(String string, INode node) throws ValueConverterException {
				if( string === null )
					return null;
				if( string.startsWith('"""') && string.endsWith('"""') )
					return string.substring(3, string.length-3)
				return string.substring(1, string.length-1)
			}
		}
	}
}