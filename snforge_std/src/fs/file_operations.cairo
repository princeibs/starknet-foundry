use core::array::ArrayTrait;
use starknet::testing::cheatcode;
use super::super::byte_array::byte_array_as_felt_array;
use super::super::_cheatcode::handle_cheatcode;

type File = ByteArray;

trait FileReader {
    /// `file` - a `File` type to read text data from
    /// Returns an array of felts read from the file, panics if read was not possible
    fn read_txt(file: @File) -> Array<felt252>;

    /// `file` - a `File` type to read json data from
    /// Returns an array of felts read from the file, panics if read was not possible, or json was incorrect
    fn read_json(file: @File) -> Array<felt252>;
}

impl FileReaderImpl of FileReader {
    fn read_txt(file: @File) -> Array<felt252> {
        let content = handle_cheatcode(
            cheatcode::<'read_txt'>(byte_array_as_felt_array(file).span())
        );

        let mut result = array![];
        result.append_span(content);
        result
    }

    fn read_json(file: @File) -> Array<felt252> {
        let content = handle_cheatcode(
            cheatcode::<'read_json'>(byte_array_as_felt_array(file).span())
        );

        let mut result = array![];
        result.append_span(content);
        result
    }
}

trait FileParser<T, impl TSerde: Serde<T>> {
    /// Reads from the text file and tries to deserialize the result into given type with `Serde`
    /// `file` - File instance
    /// Returns an instance of `T` if deserialization was possible
    fn parse_txt(file: @File) -> Option<T>;
    /// Reads from the json file and tries to deserialize the result into given type with `Serde`
    /// `file` - File instance
    /// Returns an instance of `T` if deserialization was possible
    fn parse_json(file: @File) -> Option<T>;
}

impl FileParserImpl<T, impl TSerde: Serde<T>> of FileParser<T> {
    fn parse_txt(file: @File) -> Option<T> {
        let mut content = handle_cheatcode(
            cheatcode::<'read_txt'>(byte_array_as_felt_array(file).span())
        );
        Serde::<T>::deserialize(ref content)
    }
    fn parse_json(file: @File) -> Option<T> {
        let mut content = handle_cheatcode(
            cheatcode::<'read_json'>(byte_array_as_felt_array(file).span())
        );
        Serde::<T>::deserialize(ref content)
    }
}
