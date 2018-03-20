/*AWS Provider Config.
*/

provider "aws" {
    access_key = "AKIAIB6CPJLGDMSDXZCA"
    secret_key = "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"
    region = "us-east-2"    
}

resource "aws_instance" "PRExampleServer1" {
    ami = "ami-16370073"
    instance_type = "t2.micro"
    tags {
        Name = "PSExampleServer1",
        Use = "Demo for Pluralsight"
    }
}

resource "aws_instance" "PRExampleServer2" {
    ami = "ami-16370073"
    instance_type = "t2.micro"
    tags {
        Name = "PSExampleServer2",
        Use = "Demo for Pluralsight"
    }
}